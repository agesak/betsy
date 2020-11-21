class ChangeCostDatatypeForCartitems < ActiveRecord::Migration[6.0]
  def change
    change_column :cartitems, :cost, :float
  end
end
