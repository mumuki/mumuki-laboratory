class AddCommiterToExport < ActiveRecord::Migration[4.2]
  def change
    add_column :exports, :committer_id, :integer, index: true
  end
end
