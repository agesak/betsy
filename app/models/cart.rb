class Cart < ApplicationRecord
  has_one :order
  has_many :cartitems
  has_many :products, through: :cartitems
end
