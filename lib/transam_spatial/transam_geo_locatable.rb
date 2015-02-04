#------------------------------------------------------------------------------
#
# Geolocatable
#
# Injects methods and associations for maintaining assets as spatial objects
#
# Usage:
#   Add the following line to an class
#
#   Include TransamGeoLocatable
#
#   Any class also neecd to implement the following methods
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

    # Implementing classes must set the location reference before
    # validation
    before_validation :set_location_reference

    # ----------------------------------------------------
    # Associations
    # ----------------------------------------------------

    # Type of location reference used to geocode the asset
    belongs_to :location_reference_type

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

  end

  #------------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #------------------------------------------------------------------------------

  # returns true if this instance has a geometry that can be mapped, false
  # otherwise
  def mappable?
    ! geometry.nil?
  end

  def icon_class
    return 'blueIcon'
  end

  # Returns an array of geo hashes hash representing the map markers for this asset
  def map_markers(draggable=false, zindex = 0, icon = icon_class)
    a = []
    a << map_marker(draggable, zindex, icon) unless geometry.nil?
    a
  end

  # Returns a hash representing a map marker for this asset. Note that this assumes that the geometry
  # is a point
  # TODO make this more generic for line and polygonal assets
  #
  def map_marker(draggable=false, zindex = 0, icon = icon_class)
    {
      "id" => object_key,
      "lat" => geometry.lat,
      "lng" => geometry.lon,
      "zindex" => zindex,
      "name" => name,
      "iconClass" => icon,
      "draggable" => draggable,
      "title" => name,
      "description" => description
    }
  end

  # Derive the geometry for this asset based on the parents geomtery
  def derive_geometry
    parent.present? ? parent.geometry : nil
  end

  # Default method for setting the location reference.
  def set_location_reference
    if parent.nil?
      self.location_reference_type ||= LocationReferenceType.find_by_format('NULL')
    else
      p = Asset.get_typed_asset(parent)
      self.location_reference = p.location_reference
      self.location_reference_type = p.location_reference_type
    end
  end

  # validation to ensure that a geometry can be derived from the location reference
  def validate_location_reference

    # Fail validation if the location reference type is not set
    if self.location_reference_type.nil?
      errors.add(:location_reference, "Location reference type is missing.")
      false
    elsif self.location_reference_type.format == 'NULL'
      # If the user explicitly set the type to NULL then always pass validation
      true
    elsif self.location_reference_type.format == 'DERIVED'
      # If the format is derived then call the method to derive the geometry. This
      # method must be provided by the class
      self.geometry = derive_geometry
      true
    else
      # If we get here then we use the LocationReferenceService to parse the location
      # reference and generate the geometry for us
      parser = LocationReferenceService.new({:klass => self.class, :column_name => 'geometry'})
      parser.parse(location_reference, location_reference_type.format)
      # If we found errors then stop validation and report them
      if parser.has_errors?
        errors.add(:location_reference, parser.errors)
        false
      else
        # otherwise we can store the geometry and continue with validation
        self.geometry = parser.geometry
        self.location_reference = parser.formatted_location_reference
        true
      end
    end
  end
end
