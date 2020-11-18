class RelateProductToCartItems < ActiveRecord::Migration[6.0]
  def change
    add_reference :cartitems, :product, index: true
  end
end
