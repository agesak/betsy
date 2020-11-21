class Cart < ApplicationRecord
  has_many :cartitems
  has_many :products, through: :cartitems

  validates_presence_of :email, :mailing_address, :name, :cc_number, :cc_expiration, :cc_cvv, :zip,  :if => lambda {self.status != "pending"}

end
