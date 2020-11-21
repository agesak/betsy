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
end
