class Badge < ApplicationRecord
  has_one_attached :image

  belongs_to :question   

  validates :name, presence: true
end

  
