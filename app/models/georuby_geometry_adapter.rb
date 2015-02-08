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
    @geometry_factory.geometry
  end

  # create a line string from an array of arrays
  def create_linestring(coords)
    Rails.logger.debug "Creating linestring geometry from #{coords.inspect}"
    @geometry_factory.reset
    @geometry_factory.begin_geometry(Linestring, @srid)
    coords.each do |c|
      @geometry_factory.begin_geometry(Point, @srid)
      @geometry_factory.add_point_x_y(c.first, c.last)
      @geometry_factory.end_geometry
    end
    @geometry_factory.end_geometry
    @geometry_factory.geometry
  end

  def create_polygon(coords)
    Rails.logger.debug "Creating polygon geometry from #{coords.inspect}"
    @geometry_factory.reset
    @geometry_factory.begin_geometry(Polygon, @srid)
    coords.each do |c|
      @geometry_factory.begin_geometry(Point, @srid)
      @geometry_factory.add_point_x_y(c.first, c.last)
      @geometry_factory.end_geometry
    end
    @geometry_factory.end_geometry
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