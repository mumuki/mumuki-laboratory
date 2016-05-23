class ChangeExamClassroomIdToString < ActiveRecord::Migration
  def change
    change_column :exams, :classroom_id, :string
  end
end
