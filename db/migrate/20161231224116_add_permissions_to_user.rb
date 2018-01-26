class AddPermissionsToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :permissions, :text, default: '{}', null: false
  end
end
