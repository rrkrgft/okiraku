# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.try(:admin?)
      can :access, :rails_admin
      can :manage, :all
      cannot [:destory, :edit, :update], User, email: "guest-analysis@example.com"
    end
  end
end
