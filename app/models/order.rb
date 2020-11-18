class Order < ApplicationRecord
  belongs_to :cart

  validates :email, presence: true
  validates :mailing_address, presence: true
  validates :name, presence: true
  validates :cc_number, presence: true
  validates :cc_expiration, presence: true
  validates :cc_cvv, presence: true
  validates :zip, presence: true
end
