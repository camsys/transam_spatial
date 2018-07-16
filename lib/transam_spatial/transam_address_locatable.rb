#------------------------------------------------------------------------------
#
# TransamAddressLocatable
#
# Injects methods and associations for maintainaing assets with a spatial
# reference defined via an address
#
# Usage:
#   Add the following line to an asset class
#
#   Include TransamAddressLocatable
#
#------------------------------------------------------------------------------
module TransamAddressLocatable
  extend ActiveSupport::Concern

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
    self.location_reference_type = LocationReferenceType.find_by_format('ADDRESS')
    self.location_reference = full_address
  end

  # This method defines required fields for any model which is geocodable
  def full_address
    elems = []
    elems << address1 unless address1.blank?
    elems << address2 unless address2.blank?
    elems << city unless city.blank?
    elems << state unless state.blank?
    elems << zip unless zip.blank?
    elems.compact.join(', ')
  end

end
