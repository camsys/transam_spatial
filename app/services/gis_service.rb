class GisService

  DEFAULT_SRID        = SystemConfig.instance.srid

  DEG2RAD             = 0.0174532925199433    # Pi / 180
  RAD2DEG             = 57.29577951308232     # 180 / Pi

  EARTHS_RADIUS_MILES = 3959      # earth's mean radius, miles
  EARTHS_RADIUS_KM    = 6371      # earth's mean radius, km

  DD_TO_MILES         = 65.5375   # Approximate number of miles in a decimal degree
  MILES_TO_METERS     = Uom.convert(1, Uom::MILE, Uom::METER)      # Number of meters in a mile
  MILES_TO_KM         = Uom.convert(1, Uom::MILE, Uom::KILOMETER)  # Number of kilometers in a mile

  # Allow an optional SRID to be configured. This will be added to all geometries created
  attr_accessor       :srid
  # Input unit
  attr_accessor       :input_unit
  # output_unit
  attr_accessor       :output_unit
  # klass being manipulated
  attr_accessor       :klass
  attr_accessor       :column_name

  def initialize(attrs = {})
    @srid = DEFAULT_SRID
    @input_unit = Uom::MILE
    @output_unit = Uom::MILE
    attrs.each do |k, v|
      self.send "#{k}=", v
    end
    # Create the geometry factory by using the adapter configured in the app
    @geometry_factory = TransamGeometryFactory.new(Rails.application.config.transam_spatial_geometry_adapter, @klass, @column_name, DEFAULT_SRID)
  end

  # Calulates the euclidean distance between two points and convert the units to output units
  def euclidean_distance(point1, point2)
    dist = Uom.convert(point1.euclidean_distance(point2), @input_unit, @output_unit)
  end

  def from_wkt(wkt)
    Rails.logger.debug "WELL_KNOWN_TEXT '#{wkt}'"
    @geometry_factory.create_from_wkt(wkt)
  end

  def search_box_from_bbox(bbox)

    elems = bbox.split(",")
    puts elems.inspect

    minLon = elems[0].to_f
    minLat = elems[1].to_f
    maxLon = elems[2].to_f
    maxLat = elems[3].to_f

    coords = []
    coords << [minLon, minLat]
    coords << [minLon, maxLat]
    coords << [maxLon, maxLat]
    coords << [maxLon, minLat]
    coords << [minLon, minLat]
    as_polygon(coords, true)
  end

  # Creates a Polygon geometry that can be used as a search box for spatial
  # queries. Defaults to mile
  def search_box_from_point(point, radius, unit = MILE)
    lat = point.lat
    lng = point.lon

    # Convert input units to miles and radians
    search_distance_in_miles = Uom.convert(radius, unit, MILE)
    search_distance_in_radians = search_distance_in_miles / EARTHS_RADIUS_MILES
    # Convert to decimal degrees, compensating for changes in latitude
    delta_lat = rad2deg(search_distance_in_radians)
    delta_lon = rad2deg(search_distance_in_radians/Math.cos(deg2rad(lat)))

    # bounding box (in degrees)
    maxLat = lat + delta_lat
    minLat = lat - delta_lat
    maxLon = lng + delta_lon
    minLon = lng - delta_lon

    coords = []
    coords << [minLon, minLat]
    coords << [minLon, maxLat]
    coords << [maxLon, maxLat]
    coords << [maxLon, minLat]
    coords << [minLon, minLat]
    as_polygon(coords, true)
  end

  # Converts a coordinate defined as a lat,lon into a Point geometry
  def as_point(lat, lon)
    @geometry_factory.create_point(lat, lon)
  end
  # Converts an array of coordinate pairs into a line string
  def as_linestring(coords)
    @geometry_factory.create_linestring(coords)
  end
  # Converts an array of coordinate pairs into a line string. Assumes the polygon
  # is not closed
  def as_polygon(coords, closed = false)
    @geometry_factory.create_polygon(coords, closed)
  end

  protected

  def rad2deg(r)
    r * RAD2DEG
  end

  def deg2rad(d)
    d * DEG2RAD
  end

end
