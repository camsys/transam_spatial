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
    class_attribute :property_names

  end

  #-----------------------------------------------------------------------------
  #
  # Class Methods
  #
  #-----------------------------------------------------------------------------

  module ClassMethods

    def configure_geojson(options = {})
      self.geometry_attribute_name = (options[:geometry_attribute_name] || "geometry").to_s
      self.property_names = (options[:property_names] || ["id"])
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
    property_names.each {|x| props[x] = self.send(x).to_s}
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
