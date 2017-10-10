class AddGoalToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :goal, :text, default: nil
  end
end
