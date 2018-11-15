class AddLayoutToExercise < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :layout, :integer, default: 0, null: false
  end
end
