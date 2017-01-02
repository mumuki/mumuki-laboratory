class AddPermissionsToUser < ActiveRecord::Migration
  def change
    add_column :users, :permissions, :text, default: '{}', null: false
  end
end
