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
    # Attributes
    # ----------------------------------------------------
    # The name of the attribute to use for encoding the geoJSON feature. This
    # atribute must erespond to :x and :y
    class_attribute :_geojson_geometry_attribute_name, default: 'geometry'
    # A collection of attributes to encode into the geoJSON properties list
    class_attribute :_geojson_properties, default: [:object_key]

    # ----------------------------------------------------
    # Validations
    # ----------------------------------------------------

  end

  #-----------------------------------------------------------------------------
  #
  # Class Methods
  #
  #-----------------------------------------------------------------------------

  module ClassMethods

    def configure_geojson(options = {})
      self._geojson_geometry_attribute_name = (options[:geometry_attribute_name] || :geometry).to_s
      self._geojson_properties = (options[:geojson_properties] || Rails.application.config.try(:geojson_properties) || [:object_key])
    end

  end

  #-----------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #-----------------------------------------------------------------------------

  def to_geoJSON
    geom_column = self.send(_geojson_geometry_attribute_name)
    unless geom_column.nil?
      if Rails.application.config.transam_spatial_geometry_adapter == 'rgeo'
        if geom_column.dimension == 0
          geo = {type: 'Point', coordinates: [geom_column.x, geom_column.y]}
        else
          coords = []
          geom_column.points.each {|pt| coords << [pt.x, pt.y]}
          geo = {type: 'LineString', coordinates: coords}
        end
      else
        # GeoRuby
        geo = {type: 'Point', coordinates: [geom_column.x, geom_column.y]}
      end

      props = {}
      props[:id] = self.object_key
      props[:feature_class] = self.class.name
      _geojson_properties.each {|x| props[x] = self.send(x).to_s}
      {
        type: 'Feature',
        geometry: geo,
        properties: props
      }
    end
  end
end
