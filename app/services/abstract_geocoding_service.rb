#------------------------------------------------------------------------------
#
# Abstract Geocoding Service
#
# Abstract class that is the base class for all geocoding imnpementations.
#
# Implementations must provide the following methods:
#
#   raw_results = reverse_search([x, y])
#   raw_results = search(@location_ref)
#   results     = process_results(raw_results)
#
# Additionally, parser_xxx parsers can be implemented to deal with location
# reference types where xxx is a location reference type. This generic version
# provides parsers for:
#
#   parse_address
#   parse_coordinate
#   parse_well_known_text
#
#------------------------------------------------------------------------------
class AbstractGeocodingService

  COORD_REGEX = /^(\()([-+]?)([\d]{1,2})(((\.)(\d+)(,)))(\s*)(([-+]?)([\d]{1,3})((\.)(\d+))?(\)))$/
  FLOAT_REGEX = /([+-]?\d+\.?\d+)\s*,\s*([+-]?\d+\.?\d+)/

  # Stores the raw (input) location reference for the last request
  attr_reader :location_reference
  # An array of results
  attr_reader :results
  # An array of errors. If errors are present, no results will be set
  attr_reader :errors
  # An array of warnings. Warnings can co-exist with results
  attr_reader :warnings
  # An array of coordinates representing the best result for the geocode
  attr_reader :coords
  # A formatted and sanitized version of the location reference if one is provided
  # by the geocoding service
  attr_reader :formatted_location_reference

  def initialize(attrs = {})
    # reset the current state
    reset
  end

  # Returns true if any errors were caught
  def has_errors?
    @errors.present?
  end

  #-----------------------------------------------------------------------------
  # API Methods for standard geocoding
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Performs a reverse lookup based on the lat/long (x/y)
  def reverse_lookup(lat, lon)
    Rails.logger.debug "reverse_lookup #{[lat, lon]}"
    # reset the current state
    reset
    @location_reference = [lat, lon]
    begin
      res = reverse_search(@location_reference)
      process_results(res)
    rescue Exception => e
      #Rails.logger.error format_exception(e)
      @errors << e.message
    end
    @errors.empty?
  end

  #-----------------------------------------------------------------------------
  # Performs a standard address lookup
  def lookup(raw_location_reference)
    Rails.logger.debug "lookup #{raw_location_reference}"
    # reset the current state
    reset
    @location_reference = raw_location_reference
    begin
      res = search(@location_reference)
      process_results(res)
    rescue Exception => e
      #Rails.logger.error format_exception(e)
      @errors << e.message
    end
    @errors.empty?
  end

  #------------------------------------------------------------------------------
  # generic parsers which don't need to be implemented by concrete classes
  #------------------------------------------------------------------------------
  def parse_coordinate(raw_location_reference)

    Rails.logger.debug "parse_coordinate #{raw_location_reference}"
    # reset the current state
    reset

    @location_reference = raw_location_reference
    m = COORD_REGEX.match(locref)
    if m
      # match floats in the string which are returned as an array
      matches = locref.scan(FLOAT_REGEX).flatten
      longitude = matches[0]
      latitude = matches[1]
      @formatted_location_reference = encode_coordinate(latitude, longitude)
      @geometry = @gis_service.as_point(longitude, latitude)
      @results << @formatted_location_reference
    else
      message = "Coordinate is incorrectly formatted. Use '(logitude,latitude)' format."
      @errors << message
    end
    @errors.empty?
  end

  #-----------------------------------------------------------------------------
  def parse_well_known_text(raw_location_reference)

    Rails.logger.debug "parse_well_known_text #{raw_location_reference}"
    # reset the current state
    reset

    @location_reference = raw_location_reference

    begin
      @geometry = @gis_service.from_wkt(locref)
      @formatted_location_reference = @geometry.as_wkt
      @results << @formatted_location_reference
    rescue
      message = "WKT is incorrectly formatted."
      @errors << message
    end
    @errors.empty?
  end

  #-----------------------------------------------------------------------------
  # this is for symmetry and simply delegates to the lookup method
  def parse_address(raw_address)
    Rails.logger.debug "lookup #{raw_location_reference}"
    lookup(raw_address)
  end

  #-----------------------------------------------------------------------------
  protected
  #-----------------------------------------------------------------------------

  def encode_coordinate(lng, lat)
    "(#{format_coord_part(lng)},#{format_coord_part(lat)})"
  end

  def format_coord_part(val)
    sprintf('%0.8f', val)
  end

  def reset
    @results = []
    @errors = []
    @warnings = []
    @location_reference = nil
    @formatted_location_reference = nil
    @coords = []
  end

end
