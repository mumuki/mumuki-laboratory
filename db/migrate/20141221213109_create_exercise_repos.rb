class CreateExerciseRepos < ActiveRecord::Migration
  def change
    create_table :exercise_repos do |t|
      t.string :github_url
      t.string :name
      t.references :author, index: true

      t.timestamps
    end
  end
end
