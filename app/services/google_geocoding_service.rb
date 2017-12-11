#------------------------------------------------------------------------------
#
# Address Geocoding Service that uses the Geocoder gem and Google's
# premium geocoding service
#
#------------------------------------------------------------------------------
class GoogleGeocodingService < AbstractGeocodingService

  # Google premium properties
  attr_accessor :sensor
  attr_accessor :bounds
  attr_accessor :region
  attr_accessor :components

  # list of features types to keep, everything else is filtered from the
  # google results set
  INCLUDED_TYPES = %w{
    airport
    establishment
    intersection
    natural_feature
    park
    point_of_interest
    premise
    route
    street_address
  }

  # Initialize the properties needed by the Google geocoder
  def initialize(attrs = {})
    super
    @sensor     = false
    @components = SystemConfig.instance.geocoder_components
    @bounds     = SystemConfig.instance.geocoder_bounds
    @region     = SystemConfig.instance.geocoder_region
    attrs.each do |k, v|
      self.send "#{k}=", v
    end
  end

  #-----------------------------------------------------------------------------
  protected
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Implement the abstract methods needed by abstract_geocoding_service
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Reverse lookup using the Geocoder API. Any errors thrown by the geocoder
  # are propagated to the calling function and will be dealt with there
  def reverse_search(coord)
    Rails.logger.debug "reverse_search #{coord.inspect}"
    Geocoder.search(coord)
  end

  #-----------------------------------------------------------------------------
  # Standard search based on a raw address
  def search(raw_address)
    Rails.logger.debug "search #{raw_address}"
    res = Geocoder.search(raw_address, :sensor => @sensor, :components => @components, :region => @region, :bounds => @bounds)
  end

  #-----------------------------------------------------------------------------
  # process the results returned from Google and filter out any parts we don't
  # want to keep
  def process_results(res)
    i = 0
    res.each do |alt|
      if is_valid(alt.types)
        @results << {
          :id => i,
          :name => alt.formatted_address.split(",")[0],
          :formatted_address => sanitize_formatted_address(alt.formatted_address),
          :street_address => alt.street_address,
          :city => alt.city,
          :state => alt.state_code,
          :zip => alt.postal_code,
          :lat => alt.latitude,
          :lon => alt.longitude,
          :county => alt.sub_state,
          :raw => alt
        }
        i += 1
      end
    end
    # Cache the best result if it is there
    addr = @results.first
    if addr
      @coords << [addr[:lon], addr[:lat]]
      @formatted_location_reference = addr[:formatted_address]
    end
  end

  # Google puts the country designator into the formatted address. We don't want this so we chomp the
  # end of the address string if the designator is there
  def sanitize_formatted_address(addr)
    if addr.include?(", USA")
      return addr[0..-6]
    else
      return addr
    end
  end

  # Filters addresses returned by Google to only those we want to consider
  def is_valid(addr_types)
    addr_types.each do |addr_type|
      if INCLUDED_TYPES.include?(addr_type)
        return true
      end
    end
    return false;
  end

end
