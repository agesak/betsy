class CategoryUrl < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :banner_img, :string
  end
end
