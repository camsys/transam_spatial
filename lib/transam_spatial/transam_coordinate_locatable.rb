#------------------------------------------------------------------------------
#
# TransamCoordinateLocatable
#
# Injects methods and associations for maintainaing assets with a spatial
# reference defined via given longitude and latitude
# Usage:
#   Add the following line to an asset class
#
#   Include TransamCoordinateLocatable
#
#------------------------------------------------------------------------------
module TransamCoordinateLocatable
  extend ActiveSupport::Concern

  attr_accessor :longitude
  attr_accessor :latitude

  included do

    include TransamGeoLocatable

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


  def latitude
    geometry.try(:y)
  end

  def longitude
    geometry.try(:x)
  end

  def icon_class
    return 'greenDotIcon'
  end

  # Populates the location reference with the address of the asset
  def set_location_reference
    if longitude.blank? || latitude.blank?
      self.location_reference_type = LocationReferenceType.find_by_format('NULL')
      self.location_reference = nil
    else
      self.location_reference_type = LocationReferenceType.find_by_format('COORDINATE')
      self.location_reference = "(#{longitude},#{latitude})"
    end
  end

end
