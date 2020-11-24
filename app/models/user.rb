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
    merchant_cartitems = self.cartitems

    # selected carts is a hash, where the key is a cart, and the value is an array of the user's items for that cart
    selected_carts = Hash.new { |h, k| h[k] = []} # set empty array as default value

    merchant_cartitems.each do |item|
      if item.cart.status == status
        selected_carts[item.cart] << item
      end
    end

    return selected_carts
  end

  def revenue(status)
    revenue = 0

    # is it redundant to call .merchant_orders here?  Should I rather pass it in as a parameter?
    self.merchant_orders(status).each_value do |cartitems| # cartitems is an array of cartitems
      cartitems.each do |item|
        revenue += (item.cost * item.qty)
      end
    end

    return revenue
  end

  def item_count(status)
    count = 0

    self.merchant_orders(status).each_value do |cartitems| # cartitems is an array of cartitems
      cartitems.each do |item|
        count += 1
      end
    end

    return count
  end

end
