class AddCategoryLinks < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :links, :text
  end
end
