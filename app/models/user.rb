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

end
