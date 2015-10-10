#-------------------------------------------------------------------------------
#
# TransamAssociationLocatable
#
# Injects methods and associations for maintaining assets where the spatial
# reference is derived from an associaton on the asset such as the Organization
# that owns the asset
#
# Usage:
#   Add the following line to an asset class
#
#   Include TransamAssociationLocatable
#
# Configuration
#   There are 4 configurable params that need to be passed to the plugin using the
#   configure_association_locatable() method.
#
#     association_name        -- the name of the model attribute containing the
#                                association that contains the spatial data
#
#     association_geometry_attribute_name  -- the name of the association attribute containing
#                                the spatial data. Defaults to geometry
#
#-------------------------------------------------------------------------------
module TransamAssociationLocatable
  extend ActiveSupport::Concern

  included do

    #---------------------------------------------------------------------------
    # Attributes
    #---------------------------------------------------------------------------
    class_attribute :_association_geometry_attribute_name
    class_attribute :_association_name

  end

  #-----------------------------------------------------------------------------
  # Class Methods
  #-----------------------------------------------------------------------------
  module ClassMethods

    def configure_association_locatable(options = {})
      self._association_name = options[:association_name].to_s
      self._association_geometry_attribute_name = (options[:association_geometry_attribute_name] || :geometry).to_s
    end

  end

  #------------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #------------------------------------------------------------------------------

  def icon_class
    return 'greenDotIcon'
  end

  # Derive an assets location from the location of the configured association
  def derive_geometry
    _assoc = self.send(_association_name)
    if _assoc.present?
      _geom_column = _assoc.send(_association_geometry_attribute_name)
      if _geom_column.present?
        self.geometry = _geom_column
      end
    end
  end

  # Populates the location reference with the address of the asset
  def set_location_reference
    _assoc = self.send(_association_name)
    if _assoc.nil?
      self.location_reference_type = LocationReferenceType.find_by_format('NULL')
      self.location_reference = nil
    else
      self.location_reference_type = LocationReferenceType.find_by_format('DERIVED')
      self.location_reference = "Derived from association"
    end
  end

end
