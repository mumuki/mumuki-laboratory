class RemoveGuidePosition < ActiveRecord::Migration[4.2]
  def change
    remove_column :guides, :position, :integer
  end
end
