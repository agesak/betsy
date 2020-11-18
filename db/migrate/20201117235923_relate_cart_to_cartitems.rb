class RelateCartToCartitems < ActiveRecord::Migration[6.0]
  def change
    add_reference :cartitems, :cart, index: true
  end
end
