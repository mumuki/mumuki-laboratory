class RemoveRelationship < ActiveRecord::Migration
  def change
    drop_table :relationships
  end
end
