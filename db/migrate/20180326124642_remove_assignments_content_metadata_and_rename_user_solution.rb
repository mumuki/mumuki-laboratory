class RemoveAssignmentsContentMetadataAndRenameUserSolution < ActiveRecord::Migration[5.1]
  def change
    remove_column :assignments, :submittable_solution, :string
    rename_column :assignments, :user_solution, :solution
  end
end
