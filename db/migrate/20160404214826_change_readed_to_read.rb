class ChangeReadedToRead < ActiveRecord::Migration
  def change
    rename_column :comments, :readed, :read
  end
end
