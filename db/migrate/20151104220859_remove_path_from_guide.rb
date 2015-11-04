class RemovePathFromGuide < ActiveRecord::Migration
  def change
    remove_column :guides, :path_id, :integer
  end
end
