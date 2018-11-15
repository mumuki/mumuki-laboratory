class RemoveHasMessagesFromAssignment < ActiveRecord::Migration[4.2]
  def change
    remove_column :assignments, :has_messages
  end
end
