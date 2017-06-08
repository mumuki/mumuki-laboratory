class RemoveMessageTypeColumn < ActiveRecord::Migration
  def change
    remove_column :messages, :type
  end
end
