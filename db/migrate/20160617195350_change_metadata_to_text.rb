class ChangeMetadataToText < ActiveRecord::Migration
  def change
    change_column :users, :metadata, :text, default: '{}', null: false
  end
end
