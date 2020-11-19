class AddOrderColsToCart < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :status, :string
    add_column :carts, :email, :string
    add_column :carts, :mailing_address, :string
    add_column :carts, :name, :string
    add_column :carts, :cc_number, :string
    add_column :carts, :cc_expiration, :string
    add_column :carts, :cc_cvv, :string
    add_column :carts, :zip, :string
  end
end
