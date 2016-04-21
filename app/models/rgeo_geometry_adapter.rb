#-------------------------------------------------------------------------------
#
# GeoRubyGeometryAdapter
#
# Adapter for creating geometries from a GeoRuby gem
#
#-------------------------------------------------------------------------------
class RgeoGeometryAdapter

  RGEO_FACTORY  = RGeo::Geographic.projected_factory(
    :projection_proj4 => Rails.application.config.rgeo_proj4, 
    :projection_srid => Rails.application.config.rgeo_proj4_srid) if defined?(RGeo)

  attr_reader :geometry_factory
  attr_reader :srid

  # Create a projected point from a projected coordinate
  def create_projected_point_from_projected_coord(x, y)
    Rails.logger.debug "RgeoGeometryAdapter Creating projected point geometry from x = #{x}, y = #{y}"
    @geometry_factory.projection_factory.point(x, y)    
  end

  # Create an unprojected point (lat, lng) from a projected coordinate
  def create_unprojected_point(x, y)
    Rails.logger.debug "RgeoGeometryAdapter Creating unprojected point geometry from x = #{x}, y = #{y}"
    projected_geometry = @geometry_factory.projection_factory.point(x, y)
    Rails.logger.debug "Projected Point = #{projected_geometry.to_s}"
    @geometry_factory.unproject(projected_geometry)
  end

  # Create a projected point from a lat lng
  def create_projected_point(lng, lat)
    Rails.logger.debug "RgeoGeometryAdapter Creating point geometry from lng = #{lng}, lat = #{lat}"
    @geometry_factory.project(create_point(lng, lat))
  end

  # Create an unprojected point (lat lng) from a lat lng
  def create_point(lng, lat)
    Rails.logger.debug "RgeoGeometryAdapter Creating point geometry from lng = #{lng}, lat = #{lat}"
    @geometry_factory.point(lng, lat)
  end

  # create a line string from an array of arrays. Coords are in lng lat
  def create_linestring(coords)
    Rails.logger.debug "RgeoGeometryAdapter Creating line string geometry from #{coords.inspect}"
    a = []
    coords.each do |c|
      a << @geometry_factory.point(c.first, c.last) unless c.empty?
    end
    @geometry_factory.line_string(a)
  end

  def create_polygon(coords, closed = false)
    Rails.logger.debug "RgeoGeometryAdapter Creating polygon geometry from #{coords.inspect}"
    # If the polygon is not closed we close it before creating the geometry
    a = coords
    unless closed
      a << coords.first
    end
    @geometry_factory.polygon(create_linestring(a))
  end

  def create_from_wkt(wkt)
    @geometry_factory.parse_wkt(wkt)
  end

  def initialize
    @geometry_factory = RGEO_FACTORY
    @srid = Rails.application.config.rgeo_proj4_srid
  end
end
