class Category < ApplicationRecord
  has_and_belongs_to_many :products
  validates :name, presence: true, uniqueness: true
  attribute :banner_img, :string, default: "http://lorempixel.com/1440/360/sports"
end
