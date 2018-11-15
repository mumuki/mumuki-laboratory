class RemoveAdminUser < ActiveRecord::Migration[4.2]
  def change
    drop_table :admin_users
  end
end
