class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :inventory
      t.integer :cost
      t.text :description
      t.string :image

      t.timestamps
    end
  end
end
