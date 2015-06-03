class RemoveGuideNameUniq < ActiveRecord::Migration
  def change
    remove_index :guides, :name
    add_index :guides, :name
  end
end
