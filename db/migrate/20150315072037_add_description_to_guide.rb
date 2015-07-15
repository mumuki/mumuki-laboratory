class AddDescriptionToGuide < ActiveRecord::Migration
  def change
    add_column :guides, :description, :string
    add_index :guides, :name, unique: true
  end
end
