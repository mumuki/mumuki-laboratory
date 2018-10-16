class ConvertStartingPointIntoPath < ActiveRecord::Migration[4.2]
  def change
    rename_table :starting_points, :paths

    remove_column :paths, :guide_id

    drop_table :suggested_guides

    add_column :guides, :path_id, :integer, index: true
    add_column :guides, :position, :integer
  end
end
