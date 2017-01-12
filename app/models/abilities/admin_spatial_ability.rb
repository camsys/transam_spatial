module Abilities
  class AdminSpatialAbility
    include CanCan::Ability

    def initialize(user)
      can :manage, MapOverlayService
    end
  end
end