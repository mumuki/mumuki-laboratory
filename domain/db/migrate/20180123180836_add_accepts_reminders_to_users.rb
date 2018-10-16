class AddAcceptsRemindersToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :accepts_reminders, :boolean, default: true
  end
end
