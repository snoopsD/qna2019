class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :score, inclusion: [1, -1]

  validate :author_not_vote

  private 

  def author_not_vote
    errors.add(:base, "Author can't vote") if user&.author?(votable)
  end

end
