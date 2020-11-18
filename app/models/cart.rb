class Cart < ApplicationRecord
  has_one :order
  has_many :cartitems
end
