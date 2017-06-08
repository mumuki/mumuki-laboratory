class RemoveMessagesExerciseId < ActiveRecord::Migration
  def change
    remove_column :messages, :exercise_id
  end
end
