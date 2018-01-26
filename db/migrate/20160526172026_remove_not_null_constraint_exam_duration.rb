class RemoveNotNullConstraintExamDuration < ActiveRecord::Migration[4.2]
  def change
    remove_column :exams, :duration
    add_column :exams, :duration, :integer, null: true
  end
end
