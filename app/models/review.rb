class Review < ApplicationRecord
  belongs_to :product

  validates :name, presence: true
  validates :rating, presence: true
end
