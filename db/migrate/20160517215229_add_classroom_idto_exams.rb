class AddClassroomIdtoExams < ActiveRecord::Migration[4.2]
  def change
    add_column :exams, :classroom_id, :integer
    add_index :exams, :classroom_id, unique: true
  end
end
