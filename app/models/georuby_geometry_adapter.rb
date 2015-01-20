#-------------------------------------------------------------------------------
#
# GeoRubyGeometryAdapter
#
# Adapter for creating geometries from a GeoRuby gem
#
#-------------------------------------------------------------------------------
class GeorubyGeometryAdapter

  def create_point(lat, lon)
    Rails.logger.debug "Creating point geometry from lat = #{lat}, lon = #{lon}"
    @geometry_factory.reset
    @geometry_factory.begin_geometry(Point, @srid)
    @geometry_factory.add_point_x_y(lon, lat)
    @geometry_factory.end_geometry
    Rails.logger.debug "Geometry = #{@geometry_factory.geometry}"
    @geometry_factory.geometry
  end

  def create_polygon(minLat, minLon, maxLat, maxLon)
    Rails.logger.debug "Creating polygon geometry from (#{minLat}, {minLon}), (#{maxLat}, {maxLon})"
    @geometry_factory.reset
    @geometry_factory.begin_geometry(Polygon, @srid)
    @geometry_factory.begin_geometry(Point, @srid)
    @geometry_factory.add_point_x_y(minLon, minLat)
    @geometry_factory.end_geometry
    @geometry_factory.begin_geometry(Point, @srid)
    @geometry_factory.add_point_x_y(minLon, maxLat)
    @geometry_factory.end_geometry
    @geometry_factory.begin_geometry(Point, @srid)
    @geometry_factory.add_point_x_y(maxLon, maxLat)
    @geometry_factory.end_geometry
    @geometry_factory.begin_geometry(Point, @srid)
    @geometry_factory.add_point_x_y(maxLon, minLat)
    @geometry_factory.end_geometry
    @geometry_factory.begin_geometry(Point, @srid)
    @geometry_factory.add_point_x_y(maxLon, minLat) # ensure that the polygon is closed
    @geometry_factory.end_geometry
    @geometry_factory.end_geometry
    Rails.logger.debug "Geometry = #{@geometry_factory.geometry}"
    @geometry_factory.geometry
  end

  def create_from_wkt(wkt)
    Geometry.from_ewkt(wkt)
  end

  def initialize(srid)
    @geometry_factory = GeometryFactory.new
    @srid = srid
  end

end
