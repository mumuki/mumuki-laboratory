class AddDescriptionToGuide < ActiveRecord::Migration[4.2]
  def change
    add_column :guides, :description, :string
    add_index :guides, :name, unique: true
  end
end
