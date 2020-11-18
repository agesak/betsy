class Product < ApplicationRecord
  has_many :cartitems
  has_and_belongs_to_many :categories
end
