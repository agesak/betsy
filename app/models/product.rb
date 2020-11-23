class Product < ApplicationRecord
  has_many :cartitems
  has_and_belongs_to_many :categories
  belongs_to :user

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :inventory, :cost, presence: true, numericality: { greater_than: 0 }
  validates :category_ids, presence: true


  def update_cartitems
    # update prices for cartitems in carts with the status pending
    cartitems = Cartitem.where(product: self)
    cartitems.each do |item|
      if item.cart.status == "pending"
        item.cost = self.cost
        item.save
      end
    end
  end

  def owner(current_user)
    if current_user && current_user.id == self.user.id
      return true
    else
      return false
    end
  end


end
