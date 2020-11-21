class Cartitem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  def cartitem_total
    return (self.qty * self.cost).round(2)
  end
end
