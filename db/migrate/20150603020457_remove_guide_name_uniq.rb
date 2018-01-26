class RemoveGuideNameUniq < ActiveRecord::Migration[4.2]
  def change
    remove_index :guides, :name
    add_index :guides, :name
  end
end
