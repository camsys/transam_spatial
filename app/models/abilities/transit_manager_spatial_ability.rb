module Abilities
  class TransitManagerSpatialAbility
    include CanCan::Ability

    def initialize(user)

      can :manage, MapOverlayService do |service|
        user.organization_ids.include? service.organization_id
      end

      cannot :share, MapOverlayService

    end
  end
end