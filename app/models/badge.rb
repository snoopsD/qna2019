class Badge < ApplicationRecord
  has_one_attached :image

  belongs_to :answer, optional: true
  belongs_to :question  

  validates :name, presence: true
  validate :check_image

  def check_image
    errors.add(:image, 'You must add an image file.') unless image.attached?
    errors.add(:image, 'Wrong file type.') unless image.attached? && image.content_type =~ /^image/
  end
end

  
