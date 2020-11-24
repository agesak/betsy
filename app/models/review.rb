class Review < ApplicationRecord
  belongs_to :product

  validates :name, presence: true
  validates :rating, presence: true
  validates :rating, inclusion: { in: 1..5, message: "rating needs to be between 1-5" }

end
