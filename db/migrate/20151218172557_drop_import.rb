class DropImport < ActiveRecord::Migration[4.2]
  def change
    drop_table :imports
    drop_table :exports
  end
end
