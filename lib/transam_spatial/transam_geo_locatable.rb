#------------------------------------------------------------------------------
#
# TransamGeolocatable
# -------------------
#
# Injects methods and associations for maintaining assets as spatial objects
#
# Usage:
#   Add the following line to an class
#
#   Include TransamGeoLocatable
#
#   Any class also needs to implement the following methods
#
#      set_location_reference -- this methods sets the location_reference_type
#                                and location_reference for the class instance
#
#      derive_geometry        -- this method is called if the location_reference_type
#                                is DERIVED. This method should create and return
#                                a geometry object from its relationships
#
#
#
# Configuration
#   There are 4 configurable params that need to be passed to the plugin using the
#   configure_geolocatable() method.
#
#     geometry_attribute_name -- the name of the model attribute containing the
#                                spatial data. Defaults to "geometry"
#
#     icon_class              -- the name of a method or string that returns an
#                                icon name for displaying the model when map_marker()
#                                or map_markers() is called.
#
#     update_on_save          -- a boolean that controls wether the spatial data
#                                is updated when the model is validated. Defaults
#                                to "true"
#
#     use_nodes               -- a boolean that indicates whether the geocoding
#                                service supports "nodes", primarily for SIMS.
#                                Defaults to "false".                                
#
#------------------------------------------------------------------------------
module TransamGeoLocatable
  extend ActiveSupport::Concern

  included do

    # ----------------------------------------------------
    # Callbacks
    # ----------------------------------------------------
    # Implementing classes must set the location reference before validation
    before_validation :set_location_reference

    # ----------------------------------------------------
    # Associations
    # ----------------------------------------------------
    # Type of location reference used to geocode the asset
    belongs_to :location_reference_type

    # ----------------------------------------------------
    # Attributes
    # ----------------------------------------------------
    class_attribute :_geolocatable_geometry_attribute_name
    class_attribute :_icon_class
    class_attribute :_update_on_save
    class_attribute :_use_nodes
    class_attribute :_tolerate_update_geometry_error
    
    # ----------------------------------------------------
    # Validations
    # ----------------------------------------------------
    # custom validator for location_reference
    validate  :validate_location_reference

  end

  #------------------------------------------------------------------------------
  #
  # Class Methods
  #
  #------------------------------------------------------------------------------

  module ClassMethods

    def configure_geolocatable(options = {})
      self._geolocatable_geometry_attribute_name = (options[:geometry_attribute_name] || "geometry").to_s
      self._icon_class = (options[:icon_class] || "blueIcon").to_s
      # option must explicitly be set to false
      # options[:update_on_save] = true # returns true
      # options[:update_on_save] = false # returns false
      # options[:update_on_save] = "string" # returns true
      self._update_on_save = (options[:update_on_save] != false)
      # option must explicitly be set to true
      self._use_nodes = (options[:use_nodes] == true)
      # option whether to raise error during update geometry
      self._tolerate_update_geometry_error = (options[:tolerate_update_geometry_error] == true)
    end

  end

  #------------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #------------------------------------------------------------------------------

  # returns true if this instance has a geometry that can be mapped, false
  # otherwise
  def mappable?
    self.send(_geolocatable_geometry_attribute_name).present?
  end

  # Returns an array of geo hashes hash representing the map markers for this feature
  def map_markers(draggable=false, zindex = 0, icon = _icon_class)
    a = []
    a << map_marker(draggable, zindex, icon)
    a
  end

  # Returns a hash representing a map marker for this asset. Note that this assumes that the geometry
  # is a point
  # TODO make this more generic for line and polygonal assets
  #
  def map_marker(draggable=false, zindex = 0, icon = _icon_class)
    _geom_column = self.send(_geolocatable_geometry_attribute_name)
    if _geom_column.present?
      lat = _geom_column.y
      lng = _geom_column.x
      {
        "id" => object_key,
        "lat" =>lat,
        "lng" => lng,
        "zindex" => zindex,
        "name" => name,
        "iconClass" => icon,
        "draggable" => draggable,
        "title" => name,
        "description" => description
      }
    else
      {}
    end
  end

  # Updates the spatial reference for the model based on the location reference
  # provided
  def update_geometry

    # Can't have an unset location reference type
    if self.location_reference_type.nil?
      Rails.logger.debug "location reference type is not set"
      unless _tolerate_update_geometry_error
        raise ArgumentError, "location reference type is not set"
      end
    elsif self.location_reference_type.format == 'NULL'
      # Set geom to nil
      self.send "#{_geolocatable_geometry_attribute_name}=", nil
    elsif self.location_reference_type.format == 'DERIVED'
      # Have the geom derived using the callback
      self.send "#{_geolocatable_geometry_attribute_name}=", derive_geometry
    else
      # If we get here then we use the LocationReferenceService to parse the location
      # reference and generate the geometry for us
      parser = LocationReferenceService.new
      parser.parse(location_reference, location_reference_type.format)
      # If we found errors then stop validation and report them
      if parser.has_errors?
        Rails.logger.debug "location reference service returned errors"
        unless _tolerate_update_geometry_error
          raise ArgumentError, "location reference service returned errors"
        end
      else
        # Update the location reference with the canonical form if provided by the geocoder
        self.location_reference = parser.formatted_location_reference unless parser.formatted_location_reference.blank?

        # otherwise we can store the geometry and continue with validation
        coords = parser.coords
        unless coords.empty?
          # Create a geometry factory based on whatever is configured. This assumes that all coordinates are
          # actually lat/lngs using WGS/84
          geometry_factory = TransamGeometryFactory.new(Rails.application.config.transam_spatial_geometry_adapter)
          if coords.size == 1
            # create a point
            geom = geometry_factory.create_point(coords[0].first, coords[0].last)
          elsif coords.size > 1
            # create a line string
            geom = geometry_factory.create_linestring(coords)
          else
            geom = nil
          end
          Rails.logger.debug "Geometry created = #{geom}"
          # save it to the model. If this is using the RGeo adapter we send
          # the geometry we just created to the latlng method and RGeo automatically
          # projects it
          self.send "#{_geolocatable_geometry_attribute_name}=", geom
        end

        # set nodes if used
        if _use_nodes
          if self.from_node && (self.from_node != parser.from_node)
            puts "node mismatch for #{order_number}! #{self.from_node} != #{parser.from_node}"
          else
            self.from_node = parser.from_node
          end
          if self.to_node && (self.to_node != parser.to_node)
            puts "node mismatch for #{order_number}! #{self.to_node} != #{parser.to_node}"
          else
            self.to_node = parser.to_node
          end
        end
      end
    end
  end

  # validation to ensure that a geometry can be derived from the location reference
  def validate_location_reference

    Rails.logger.debug "in validate_location_reference"

    # Fail validation if the location reference type is not set
    if self.location_reference_type.nil?
      errors.add(:location_reference, "Location reference type is missing.")
      result = false
    elsif self.location_reference_type.format == 'NULL'
      # If the user explicitly set the type to NULL then always pass validation
      # and ensure that the geometry column is nulled
      result = true
    elsif self.location_reference_type.format == 'DERIVED'
      # If the format is derived then call the method to derive the geometry. This
      # method must be provided by the class
      result = true
    else
      # If we get here then we use the LocationReferenceService to parse the location
      # reference and generate the geometry for us
      parser = LocationReferenceService.new
      parser.parse(location_reference, location_reference_type.format)
      # If we found errors then stop validation and report them
      if parser.has_errors?
        errors.add(:location_reference, parser.errors)
        result = false
      else
        result = true
      end
    end
    # If there are no validation errrors and the app requested that the geom is
    # updated on validation then perform the update
    if result == true and _update_on_save == true
      update_geometry
    end
    result
  end
end
