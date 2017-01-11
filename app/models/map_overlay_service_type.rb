#-------------------------------------------------------------------------------
#
# MapOverlayServiceType
#
# Lookup table to list all available map overlay service types,e.g., 
#   Esri Map Service, Esri Feature Service
#
#-------------------------------------------------------------------------------
class MapOverlayServiceType < ActiveRecord::Base
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  has_many :map_overlay_services

  def to_s
    name
  end
end