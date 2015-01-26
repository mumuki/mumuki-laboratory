class AddHintToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :hint, :text
  end
end
