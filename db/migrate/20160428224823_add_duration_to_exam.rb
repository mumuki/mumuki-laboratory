class AddDurationToExam < ActiveRecord::Migration
  def change
    add_column :exams, :duration, :integer, null: false
  end
end
