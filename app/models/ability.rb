class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end
  
  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can %i[update destroy], [Question, Answer], user_id: user.id
    can %i[voteup votedown], [Question, Answer]
    cannot %i[voteup votedown], [Question, Answer], user_id: user.id
    can :index, Badge
    can :best, Answer do |answer|
      user.author?(answer.question) && !user.author?(answer)
    end

    can :destroy, ActiveStorage::Attachment, record: { user_id: user.id }
  end
end
