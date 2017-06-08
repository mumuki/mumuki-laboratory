class RenameCommentToMessages < ActiveRecord::Migration
  def change
    rename_table :comments, :messages
    rename_column :messages, :author, :sender
  end
end
