class AddPointsToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :max_points, :integer, default: 10
  end
end
