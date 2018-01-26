class ChangeCategoryDescriptionToText < ActiveRecord::Migration[4.2]
  def change
    change_column :categories, :description, :text
  end
end
