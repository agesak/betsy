class User < ApplicationRecord

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

end
