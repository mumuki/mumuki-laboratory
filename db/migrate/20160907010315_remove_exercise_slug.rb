class RemoveExerciseSlug < ActiveRecord::Migration
  def change
    remove_column :exercises, :slug
  end
end
