class Product < ApplicationRecord
  has_many :cartitems
  has_and_belongs_to_many :categories
  belongs_to :user

  validates :name, :description, :image, presence: true
  validates :inventory, :cost, presence: true, numericality: { greater_than: 0 }
  validates :category_ids, presence: true

  def owner(current_user)
    if current_user && current_user.id == self.user.id
      return true
    else
      return false
    end
  end

end
