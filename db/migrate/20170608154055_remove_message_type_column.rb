class RemoveMessageTypeColumn < ActiveRecord::Migration[4.2]
  def change
    remove_column :messages, :type
  end
end
