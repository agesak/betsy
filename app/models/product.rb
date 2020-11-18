class Product < ApplicationRecord
  has_many :cartitems
  has_and_belongs_to_many :categories

  validates :name, :description, :image, presence: true
  validates :inventory, :cost, presence: true, numericality: true
  validates :category_ids, presence: true
end
