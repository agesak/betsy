class Order < ApplicationRecord
  belongs_to :cart
  has_many :cartitems, through: :cart

  validates :email, :mailing_address, :name, :cc_number, :cc_expiration, :cc_cvv, :zip, :cartitems, presence: true

end
