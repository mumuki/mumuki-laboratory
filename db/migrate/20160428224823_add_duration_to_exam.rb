class AddDurationToExam < ActiveRecord::Migration[4.2]
  def change
    add_column :exams, :duration, :integer, null: false
  end
end
