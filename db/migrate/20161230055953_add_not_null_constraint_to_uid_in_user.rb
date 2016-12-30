class AddNotNullConstraintToUidInUser < ActiveRecord::Migration
  def change
    change_column :users, :uid, :string, null: false
  end
end
