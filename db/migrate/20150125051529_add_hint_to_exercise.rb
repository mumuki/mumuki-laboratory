class AddHintToExercise < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :hint, :text
  end
end
