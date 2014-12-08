class AddSubmissionsCountToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :submissions_count, :integer, index: true
  end
end
