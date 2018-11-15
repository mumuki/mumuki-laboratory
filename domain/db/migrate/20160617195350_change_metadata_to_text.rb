class ChangeMetadataToText < ActiveRecord::Migration[4.2]
  def change
    change_column :users, :metadata, :text, default: '{}', null: false
  end
end
