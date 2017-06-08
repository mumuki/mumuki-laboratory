class AddHasMessagesFlagToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :has_messages, :boolean, default: false
  end
end
