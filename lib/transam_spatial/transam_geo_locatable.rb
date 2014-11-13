module TransamGeoLocatable
  extend ActiveSupport::Concern
  
  included do

    # ----------------------------------------------------  
    # Callbacks
    # ----------------------------------------------------  

    # Implementing classes must set the location reference before
    # validation
    before_validation :set_location_reference

    # ----------------------------------------------------  
    # Associations
    # ----------------------------------------------------  
       
    # Type of location reference used to geocode the asset
    belongs_to :location_reference_type
    
    # ----------------------------------------------------  
    # Validations
    # ----------------------------------------------------  
    
    validates :location_reference_type, :presence => true
    validates :location_reference,      :presence => true

    # custom validator for location_reference
    validate  :validate_location_reference
        
  end

  #------------------------------------------------------------------------------
  #
  # Class Methods
  #
  #------------------------------------------------------------------------------

  module ClassMethods

  end

  #------------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #------------------------------------------------------------------------------

  # returns true if this instance has a geometry that can be mapped, false
  # otherwise
  def mappable?
    ! geometry.nil?
  end
    
  def icon_class
    return 'blueIcon'
  end
  
  # Returns a JSON hash representing a map marker for this asset  
  def map_markers(draggable=false, zindex = 0, icon = icon_class)
    [{
      "id" => object_key,
      "lat" => geometry.lat,
      "lng" => geometry.lon,
      "zindex" => zindex,
      "name" => name,
      "iconClass" => icon,
      "draggable" => draggable,
      "title" => name,
      "description" => description
    }].to_json
  end
    
  # validation to ensure that a coordinate can be derived from the location reference
  def validate_location_reference
    if location_reference_type_id.nil?
      return false
    end
    
    parser = LocationReferenceService.new
    type = LocationReferenceType.find(location_reference_type_id)
    parser.parse(location_reference, type.format)
    if parser.errors.empty?
      self.geometry = parser.geometry
      self.location_reference = parser.formatted_location_reference
      return true
    else
      errors.add(:location_reference, parser.errors)
      return false      
    end
  end
      
end
