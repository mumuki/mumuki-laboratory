class RemoveHasMessagesFromAssignment < ActiveRecord::Migration
  def change
    remove_column :assignments, :has_messages
  end
end
