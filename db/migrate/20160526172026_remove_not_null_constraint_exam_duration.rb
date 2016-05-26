class RemoveNotNullConstraintExamDuration < ActiveRecord::Migration
  def change
    remove_column :exams, :duration
    add_column :exams, :duration, :integer, null: true
  end
end
