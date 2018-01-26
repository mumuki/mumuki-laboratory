class RemoveAdminComments < ActiveRecord::Migration[4.2]
  def change
    drop_table :active_admin_comments
  end
end
