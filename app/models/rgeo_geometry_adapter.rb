#-------------------------------------------------------------------------------
#
# GeoRubyGeometryAdapter
#
# Adapter for creating geometries from a GeoRuby gem
#
#-------------------------------------------------------------------------------
class RgeoGeometryAdapter

  RGEO_FACTORY  = RGeo::Geographic.projected_factory(:projection_proj4 => Rails.application.config.nycdot_proj4, :projection_srid => Rails.application.config.nycdot_proj_srid)

  attr_reader :geometry_factory
  attr_reader :srid

  def create_point(lat, lon)
    Rails.logger.debug "Creating point geometry from lat = #{lat}, lon = #{lon}"
    @geometry_factory.point(lat, lon)
  end

  # create a line string from an array of arrays
  def create_linestring(coords)
    Rails.logger.debug "Creating line string geometry from #{coords.inspect}"
    a = []
    coords.each do |c|
      a << @geometry_factory.point(c.first, c.last)
    end
    @geometry_factory.line_string(a)
  end

  def create_polygon(coords, closed = false)
    Rails.logger.debug "Creating polygon geometry from #{coords.inspect}"
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
    @srid = Rails.application.config.nycdot_proj_srid
  end
end
