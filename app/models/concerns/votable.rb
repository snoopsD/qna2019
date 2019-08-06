module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def voteup(user)
    vote(1, user)
  end 

  def votedown(user)
    vote(-1, user)
  end

  def rate
    votes.sum(:score)
  end  

  private 

  def vote(score, user)
    vote = votes.where(user: user, score: score)
    
    if vote.exists?
      votes.where(user: user).first.destroy
    else  
      votes.create(score: score, user: user)
    end 

  end

end
