class ChangeExamClassroomIdToString < ActiveRecord::Migration[4.2]
  def change
    change_column :exams, :classroom_id, :string
  end
end
