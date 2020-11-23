class Review < ApplicationRecord
  belongs_to :product

  validates :name, presence: true
  validates_presence_of :rating, message: "must give a rating"

end
