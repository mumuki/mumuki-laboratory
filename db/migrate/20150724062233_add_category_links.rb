class AddCategoryLinks < ActiveRecord::Migration
  def change
    add_column :categories, :links, :text
  end
end
