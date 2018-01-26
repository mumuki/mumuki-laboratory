class AddIndexToUid < ActiveRecord::Migration[4.2]
  def change
    add_index :users, :uid, unique: true
  end
end
