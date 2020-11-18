class Order < ApplicationRecord
  belongs_to :cart

  validates :email, :mailing_address, :name, :cc_number, :cc_expiration, :cc_cvv, :zip, presence: true

end
