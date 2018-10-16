class RenameCommentToMessages < ActiveRecord::Migration[4.2]
  def change
    rename_table :comments, :messages
    rename_column :messages, :author, :sender
  end
end
