class CreateCartitems < ActiveRecord::Migration[6.0]
  def change
    create_table :cartitems do |t|
      t.integer :qty
      t.integer :cost

      t.timestamps
    end
  end
end
