class AddClassroomIdtoExams < ActiveRecord::Migration
  def change
    add_column :exams, :classroom_id, :integer
    add_index :exams, :classroom_id, unique: true
  end
end
