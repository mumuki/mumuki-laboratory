class AddCommiterToExport < ActiveRecord::Migration
  def change
    add_column :exports, :committer_id, :integer, index: true
  end
end
