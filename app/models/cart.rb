class Cart < ApplicationRecord
  has_many :cartitems
  has_many :products, through: :cartitems

  validates_presence_of :email, :mailing_address, :name, :cc_number, :cc_expiration, :cc_cvv, :zip,  :if => lambda {self.status != "pending"}
  
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

  def update_item_fulfillment
    self.cartitems.each do |item|
      item.fulfillment_status = "order placed"
      item.save
    end
  end

  def complete_cart
    complete_cart = self.cartitems.all? { |item| item.fulfillment_status == "order shipped" }

    if complete_cart
      self.status = "complete"
      self.save
    end
  end

end
