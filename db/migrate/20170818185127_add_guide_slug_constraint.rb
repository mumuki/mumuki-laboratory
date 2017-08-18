class AddGuideSlugConstraint < ActiveRecord::Migration
  def change
    add_index :guides, :slug, unique: true
  end
end
