class ChangeReadedToRead < ActiveRecord::Migration[4.2]
  def change
    rename_column :comments, :readed, :read
  end
end
