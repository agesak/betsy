class User < ApplicationRecord
  has_many :products
  has_many :cartitems, through: :products

  validates :uid, uniqueness: { scope: :provider}, presence: true
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.provider = "github"
    user.username = auth_hash["info"]["nickname"]
    user.name = auth_hash["info"]["name"]
    user.email = auth_hash["info"]["email"]
    user.image = auth_hash["info"]["image"]
    return user
  end

  def self.merchants
    @merchants = []

    User.all.each do |user|
      if user.products.length > 0
        @merchants << user
      end
    end
    return @merchants
  end

  def merchant_orders(status)
    #from a user's cartitems, return the carts associated that have a certain cart status
    # this guard clause below doesn't do anything?  based on the tests
    return nil if self.nil? || self.cartitems.nil?

    merchant_cartitems = self.cartitems

    # selected carts is a hash, where the cart id is the key and the cart is the value in order to make it easier to check if that cart is already in the list when iterating thru cartitems
    selected_carts = {}

    merchant_cartitems.each do |item|
      if item.cart.status == status && !selected_carts[item.cart.id]
        selected_carts[item.cart.id] = item.cart
      end
    end
    return selected_carts
  end

end
