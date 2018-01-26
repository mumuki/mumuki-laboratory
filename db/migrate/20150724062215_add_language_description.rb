class AddLanguageDescription < ActiveRecord::Migration[4.2]
  def change
    add_column :languages, :description, :text
  end
end
