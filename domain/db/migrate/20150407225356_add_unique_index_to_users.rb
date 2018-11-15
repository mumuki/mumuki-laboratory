class AddUniqueIndexToUsers < ActiveRecord::Migration[4.2]
  def change
    add_index :users, :name, unique: true
  end
end
