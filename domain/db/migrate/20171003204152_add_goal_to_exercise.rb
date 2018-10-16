class AddGoalToExercise < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :goal, :text, default: nil
  end
end
