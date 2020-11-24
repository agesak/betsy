class AddPurchaseDatetimeToCarts < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :purchase_datetime, :datetime
  end
end
