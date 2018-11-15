class ChangeExerciseDescriptionToText < ActiveRecord::Migration[4.2]
  def change
    change_column :exercises, :description, :text
  end
end
