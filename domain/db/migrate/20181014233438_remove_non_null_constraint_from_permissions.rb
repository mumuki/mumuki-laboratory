class RemoveNonNullConstraintFromPermissions < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :permissions, :text, null: true, default: nil
  end
end
