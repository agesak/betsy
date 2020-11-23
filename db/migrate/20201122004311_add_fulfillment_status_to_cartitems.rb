class AddFulfillmentStatusToCartitems < ActiveRecord::Migration[6.0]
  def change
    add_column :cartitems, :fulfillment_status, :string
  end
end
