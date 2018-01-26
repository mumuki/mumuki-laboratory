class AddNotNullConstraintToUidInUser < ActiveRecord::Migration[4.2]
  def change
    change_column :users, :uid, :string, null: false
  end
end
