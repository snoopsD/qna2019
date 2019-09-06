class Answer < ApplicationRecord
  include Votable
  include Commentable
  
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable
  has_one :badge
  
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  default_scope {order(best: :desc)}

  after_commit :subscribe_job, on: :create

  def check_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      update!(badge: question.badge) if question.badge
    end  
  end

  private

  def subscribe_job
    AnswersNotifyJob.perform_later(self)
  end
  
end
