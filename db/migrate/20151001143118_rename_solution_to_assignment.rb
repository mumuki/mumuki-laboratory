class RenameSolutionToAssignment < ActiveRecord::Migration[4.2]
  def change
    rename_table :solutions, :assignments
  end
end
