class AddCategoryLongDescription < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :long_description, :text
  end
end
