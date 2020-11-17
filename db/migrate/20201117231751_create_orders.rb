class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :email
      t.string :mailing_address
      t.string :name
      t.string :cc_number
      t.string :cc_expiration
      t.string :cc_cvv
      t.string :zip

      t.timestamps
    end
  end
end
