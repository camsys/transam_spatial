#-------------------------------------------------------------------------------
#
# GeoRubyGeometryAdapter
#
# Adapter for creating geometries from a GeoRuby gem
#
#-------------------------------------------------------------------------------
class RgeoGeometryAdapter

  def create_point(lat, lon)
    Rails.logger.debug "Creating point geometry from lat = #{lat}, lon = #{lon}"
    @geometry_factory.point(lat, lon)
  end

  def create_polygon(minLat, minLon, maxLat, maxLon)
    Rails.logger.debug "Creating polygon geometry from (#{minLat}, #{minLon}), (#{maxLat}, #{maxLon})"
    a = []
    a << @geometry_factory.point(minLon, minLat)
    a << @geometry_factory.point(minLon, maxLat)
    a << @geometry_factory.point(maxLon, maxLat)
    a << @geometry_factory.point(maxLon, minLat)
    a << @geometry_factory.point(minLon, minLat)
    line_string = @geometry_factory.line_string(a)
    @geometry_factory.polygon(line_string)
  end

  def create_from_wkt(wkt)
    @geometry_factory.parse_wkt(wkt)
  end

  def initialize
    @geometry_factory = RGeo::Cartesian.factory
  end
end
