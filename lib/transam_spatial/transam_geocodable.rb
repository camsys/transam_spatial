###############################################################################
#
# TransamGeocodable
# Unlike geolocatable, which populates a geometry (WellKnownText?) attribute,
# .geocodable populates lat/long fields based on an address.  This is simply
# a point on the map, rather than an area.
#
# requires     :latitude,:longitude added to the model
#
###############################################################################
module TransamGeocodable
  extend ActiveSupport::Concern

  included do

    # ----------------------------------------------------
    # Callbacks
    # ----------------------------------------------------

    # Enable automatic geocoding using the Geocoder gem
    geocoded_by       :full_address
    after_validation  :geocode

    # ----------------------------------------------------
    # Associations
    # ----------------------------------------------------

    # ----------------------------------------------------
    # Validations
    # ----------------------------------------------------


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
    return 'blueIcon'
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
