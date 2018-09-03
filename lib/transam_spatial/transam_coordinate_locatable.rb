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

  def icon_class
    return 'greenDotIcon'
  end

  # Populates the location reference with the address of the asset
  def set_location_reference
    self.location_reference_type = LocationReferenceType.find_by_format('COORDINATE')
    self.location_reference = "(#{longitude},#{latitude})"
  end

end
