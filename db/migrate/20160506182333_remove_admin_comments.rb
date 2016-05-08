class RemoveAdminComments < ActiveRecord::Migration
  def change
    drop_table :active_admin_comments
  end
end
