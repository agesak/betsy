class RelateOrdersToCarts < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :cart, index: true
  end
end
