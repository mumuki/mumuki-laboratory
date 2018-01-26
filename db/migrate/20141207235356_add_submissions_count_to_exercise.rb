class AddSubmissionsCountToExercise < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :submissions_count, :integer, index: true
  end
end
