class RenameExerciseRepoToGuide < ActiveRecord::Migration[4.2]
  def change
    rename_table :exercise_repos, :guides
    rename_column :exercises, :origin_id, :guide_id
  end
end
