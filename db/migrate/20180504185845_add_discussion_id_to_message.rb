class AddDiscussionIdToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :discussion_id, :integer
  end
end
