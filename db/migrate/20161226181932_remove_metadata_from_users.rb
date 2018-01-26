class RemoveMetadataFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :metadata
  end
end
