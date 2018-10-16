class ChangeContentCommentToText < ActiveRecord::Migration[4.2]
  def change
    change_column :comments, :content, :text
  end
end
