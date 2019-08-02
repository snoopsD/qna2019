class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable
  has_one :badge
  
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  default_scope {order(best: :desc)}

  def check_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      update!(badge: question.badge) if question.badge
    end  
  end
  
end
