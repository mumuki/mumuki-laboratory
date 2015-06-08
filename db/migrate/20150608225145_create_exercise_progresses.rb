class CreateExerciseProgresses < ActiveRecord::Migration
  def change
    create_table :exercise_progresses do |t|
      t.references :user, index: true
      t.references :exercise, index: true
      t.references :last_submission, index: true

      t.timestamps
    end
  end
end
