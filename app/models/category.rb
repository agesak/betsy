class Category < ApplicationRecord
  has_and_belongs_to_many :products
  validates :name, presence: true, uniqueness: true
  before_create :set_default_image

  def set_default_image
    unless banner_img.present?
      self.banner_img = "http://lorempixel.com/1440/360/sports"
    end
  end

end