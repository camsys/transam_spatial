#-------------------------------------------------------------------------------
#
# GeoJSONFeature
#
# Injects methods for managing a class as a RGeo feature collection
#
# Usage:
#   Add the following line to an asset class
#
#   Include TransamGeoJSONFeature
#
# Each implementing class will need to provide the following instance method
# def geoJSON_property_names
#   [:attr1, :attr2]
# end
#
# where attr1 and attr2 are properties and have a valid to_s implementation.
# This method should return a set of attributes that will be loaded into the
# geoJSON feature. Note that :id => :object_key is always added and does not
# need to be included in the list
#
#_------------------------------------------------------------------------------
module TransamGeoJSONFeature
  extend ActiveSupport::Concern

  included do

    # ----------------------------------------------------
    # Callbacks
    # ----------------------------------------------------

    # ----------------------------------------------------
    # Associations
    # ----------------------------------------------------

    # ----------------------------------------------------
    # Validations
    # ----------------------------------------------------

    # ----------------------------------------------------
    # Attributes
    # ----------------------------------------------------
    class_attribute :geometry_attribute_name

  end

  #-----------------------------------------------------------------------------
  #
  # Class Methods
  #
  #-----------------------------------------------------------------------------

  module ClassMethods

    def configure_geojson(options = {})
      self.geometry_attribute_name = (options[:geometry_attribute_name] || "geometry").to_s
    end

  end

  #-----------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #-----------------------------------------------------------------------------

  def to_geoJSON
    g = self.send(geometry_attribute_name)
    props = {}
    props[:id] = self.object_key
    geoJSON_property_names.each {|x| props[x] = self.send(x).to_s}
    unless g.nil?
      {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [g.longitude, g.latitude]
        },
        properties: props
      }
    end
  end
end
