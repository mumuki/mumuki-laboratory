class RenameAssignmentsContentMetadataAndSolution < ActiveRecord::Migration[5.1]
  def change
    rename_column :assignments, :content_metadata, :user_solution
    rename_column :assignments, :solution, :submittable_solution
  end
end
