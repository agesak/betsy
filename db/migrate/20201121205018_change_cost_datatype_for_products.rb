class ChangeCostDatatypeForProducts < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :cost, :float
  end
end
