class Cartitem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  # has_one :order, through: :cart
end
