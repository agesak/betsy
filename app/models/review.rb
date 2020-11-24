class Review < ApplicationRecord
  belongs_to :product

  validates :name, presence: true
  validates_presence_of :rating, message: "must give a rating"
  validates :rating, :inclusion => 1..5

end
