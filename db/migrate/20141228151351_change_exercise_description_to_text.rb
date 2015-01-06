class ChangeExerciseDescriptionToText < ActiveRecord::Migration
  def change
    change_column :exercises, :description, :text
  end
end
