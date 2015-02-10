#------------------------------------------------------------------------------
#
# TransamGeolocatable
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

  # validation to ensure that a geometry can be derived from the location reference
  def validate_location_reference

    Rails.logger.debug "in validate_location_reference"

    # Fail validation if the location reference type is not set
    if self.location_reference_type.nil?
      errors.add(:location_reference, "Location reference type is missing.")
      false
    elsif self.location_reference_type.format == 'NULL'
      # If the user explicitly set the type to NULL then always pass validation
      # and ensure that the geometry column is nulled
      self.send "#{_geolocatable_geometry_attribute_name}=", nil
      true
    elsif self.location_reference_type.format == 'DERIVED'
      # If the format is derived then call the method to derive the geometry. This
      # method must be provided by the class
      self.send "#{_geolocatable_geometry_attribute_name}=", derive_geometry
      true
    else
      # If we get here then we use the LocationReferenceService to parse the location
      # reference and generate the geometry for us
      parser = LocationReferenceService.new
      parser.parse(location_reference, location_reference_type.format)
      # If we found errors then stop validation and report them
      if parser.has_errors?
        errors.add(:location_reference, parser.errors)
        false
      else
        # otherwise we can store the geometry and continue with validation

        # Update the location reference with the canonical form if provided by the geocoder
        self.location_reference = parser.formatted_location_reference unless parser.formatted_location_reference.blank?

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
        true
      end
    end
  end
end
