module Abilities
  class ManagerSpatialAbility
    include CanCan::Ability

    def initialize(user)

      can :manage, MapOverlayService

    end
  end
end