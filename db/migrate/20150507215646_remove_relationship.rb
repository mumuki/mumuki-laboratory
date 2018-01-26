class RemoveRelationship < ActiveRecord::Migration[4.2]
  def change
    drop_table :relationships
  end
end
