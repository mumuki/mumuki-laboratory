class AddStartEndTimeToExam < ActiveRecord::Migration[4.2]
  def change
    add_column :exams, :start_time, :datetime, null: false
    add_column :exams, :end_time, :datetime, null: false
  end
end
