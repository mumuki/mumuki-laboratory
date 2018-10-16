class AddLastRemindedDateToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_reminded_date, :datetime
  end
end
