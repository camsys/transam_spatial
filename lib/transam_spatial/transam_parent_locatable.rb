#------------------------------------------------------------------------------
#
# TransamParentLocatable
#
# Injects methods and associations for maintaining assets where the spatial
# reference is derived from the assets parent, if there is one.
#
# Usage:
#   Add the following line to an asset class
#
#   Include TransamParentLocatable
#
#------------------------------------------------------------------------------
module TransamParentLocatable
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
    return 'purpleIcon'
  end

  # Derive an assets location from the location
  def derive_geometry
    unless location.nil?
      self.geometry = location.geometry
    end
  end

  # Populates the location reference with the address of the asset
  def set_location_reference
    if self.location.nil?
      self.location_reference_type = LocationReferenceType.find_by_format('NULL')
      self.location_reference = nil
    else
      self.location_reference_type = LocationReferenceType.find_by_format('DERIVED')
      self.location_reference = "Derived from location"
    end
  end

end
