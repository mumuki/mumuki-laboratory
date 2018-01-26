class RemoveUniqueIndexFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_index :users, :name
  end
end
