class Cart < ApplicationRecord
  has_many :cartitems
  has_many :products, through: :cartitems

  def update_inventory
    self.cartitems.each do |item|
      product = item.product
      product.inventory -= item.qty
      product.save
    end
  end

  def total_price
    total_price = 0

    self.cartitems.each do |item|
      total_price += item.cartitem_subtotal
    end

    return total_price.round(2)
  end

end
