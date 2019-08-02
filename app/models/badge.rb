class Badge < ApplicationRecord
  belongs_to :answer, optional: true
  belongs_to :question  

  has_one_attached :image

  validates :name, presence: true
  validate :check_image

  private

  def check_image
    errors.add(:image, 'You must add an image file.') unless image.attached?
    errors.add(:image, 'Wrong file type.') unless image.attached? && image.content_type =~ /^image/
  end
end

  
