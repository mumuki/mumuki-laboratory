class AddMetadataToUser < ActiveRecord::Migration
  def change
    add_column :users, :metadata, :string, default: '{}', null: false
  end
end
