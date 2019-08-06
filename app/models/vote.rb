class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validate :author_not_vote

  private 

  def author_not_vote
    errors.add(:base, "Author can't vote") if user&.author?(votable)
  end

end
