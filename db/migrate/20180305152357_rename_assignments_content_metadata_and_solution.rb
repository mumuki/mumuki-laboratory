class RenameAssignmentsContentMetadataAndSolution < ActiveRecord::Migration[5.1]
  def change
    rename_column :assignments, :content_metadata, :submittable_solution
    rename_column :assignments, :solution, :user_solution
  end
end
