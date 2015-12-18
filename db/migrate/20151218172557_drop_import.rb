class DropImport < ActiveRecord::Migration
  def change
    drop_table :imports
    drop_table :exports
  end
end
