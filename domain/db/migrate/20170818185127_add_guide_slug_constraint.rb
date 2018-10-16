class AddGuideSlugConstraint < ActiveRecord::Migration[4.2]
  def change
    add_index :guides, :slug, unique: true
  end
end
