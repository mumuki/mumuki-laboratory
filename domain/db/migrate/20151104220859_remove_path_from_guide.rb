class RemovePathFromGuide < ActiveRecord::Migration[4.2]
  def change
    remove_column :guides, :path_id, :integer
  end
end
