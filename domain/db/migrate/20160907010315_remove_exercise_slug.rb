class RemoveExerciseSlug < ActiveRecord::Migration[4.2]
  def change
    remove_column :exercises, :slug
  end
end
