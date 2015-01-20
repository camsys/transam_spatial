#------------------------------------------------------------------------------
#
# Geolocatable
#
# Injects methods and associations for maintainaing assets as spatial objects
#
# Usage:
#   Add the following line to an asset class
#
#   Include TransamGeoLocatable
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

  # Returns a hash representing a map marker for this asset. Nothe that this assumes that the geometry
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

  # Update the geometry for this asset from the parent's geometry
  def set_geometry_from_parent

    # Only set the geometry if the asset has a location set
    if geometry.nil? and parent.present?
      self.geometry = parent.geometry
    end

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

  # validation to ensure that a coordinate can be derived from the location reference
  def validate_location_reference

    # Fail validation if the location reference type is not set
    if self.location_reference_type.nil?
      return false
    end

    # If the user explicitly set the type to NULL then always pass validation
    if self.location_reference_type.format == 'NULL'
      return true
    end

    parser = LocationReferenceService.new({:klass => self.class, :column_name => 'geometry'})
    parser.parse(location_reference, location_reference_type.format)
    if parser.errors.empty?
      self.geometry = parser.geometry
      self.location_reference = parser.formatted_location_reference
      return true
    else
      errors.add(:location_reference, parser.errors)
      return false
    end
  end
end
