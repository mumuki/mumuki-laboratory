class AddCommitterToImport < ActiveRecord::Migration
  def change
    add_column :imports, :committer_id, :integer, index: true
  end
end
