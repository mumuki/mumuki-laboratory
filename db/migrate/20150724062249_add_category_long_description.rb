class AddCategoryLongDescription < ActiveRecord::Migration
  def change
    add_column :categories, :long_description, :text
  end
end
