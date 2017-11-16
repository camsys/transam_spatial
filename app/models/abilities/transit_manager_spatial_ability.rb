module Abilities
  class TransitManagerSpatialAbility
    include CanCan::Ability

    def initialize(user, organization_ids=[])

      if organization_ids.empty?
        organization_ids = Organization.ids
      end

      can :manage, MapOverlayService do |service|
        organization_ids.include? service.organization_id
      end

      cannot :share, MapOverlayService

    end
  end
end