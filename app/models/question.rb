class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :user
  has_one :badge, dependent: :destroy
  has_many :subscribes, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :badge, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
  
  after_create :subscribe_author

  private 

  def subscribe_author
    Subscribe.create!(user: user, question: self)
  end
  
end
