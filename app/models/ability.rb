# Define permissoes de autorizacao
class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
      cannot :destroy, User, id: user.id 
    else
      can :update, Quiz, evaluator_id: user.id
      can :show, Quiz, evaluator_id: user.id
      can :update, User, id: user.id
      can :show, User, id: user.id
    end
  end
end
