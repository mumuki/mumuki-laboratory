class AddPositionToExercise < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :position, :integer
  end
end
