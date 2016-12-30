class RemoveMetadataFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :metadata
  end
end
