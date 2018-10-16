class AddHasMessagesFlagToAssignment < ActiveRecord::Migration[4.2]
  def change
    add_column :assignments, :has_messages, :boolean, default: false
  end
end
