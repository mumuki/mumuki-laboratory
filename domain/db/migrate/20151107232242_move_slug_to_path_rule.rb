class MoveSlugToPathRule < ActiveRecord::Migration[4.2]
  def change
    remove_column :guides, :slug, :string
    add_column :path_rules, :slug, :string, unique: true
  end
end
