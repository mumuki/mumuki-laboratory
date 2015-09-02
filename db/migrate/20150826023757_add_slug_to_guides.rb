class AddSlugToGuides < ActiveRecord::Migration
  def change
    add_column :guides, :slug, :string
    add_index :guides, :slug, unique: true
  end
end
