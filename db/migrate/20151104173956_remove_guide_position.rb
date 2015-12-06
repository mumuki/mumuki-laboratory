class RemoveGuidePosition < ActiveRecord::Migration
  def change
    remove_column :guides, :position, :integer
  end
end
