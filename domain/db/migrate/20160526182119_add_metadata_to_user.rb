class AddMetadataToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :metadata, :string, default: '{}', null: false
  end
end
