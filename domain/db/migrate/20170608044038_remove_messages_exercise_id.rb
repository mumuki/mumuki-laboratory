class RemoveMessagesExerciseId < ActiveRecord::Migration[4.2]
  def change
    remove_column :messages, :exercise_id
  end
end
