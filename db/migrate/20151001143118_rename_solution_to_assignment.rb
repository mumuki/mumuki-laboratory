class RenameSolutionToAssignment < ActiveRecord::Migration
  def change
    rename_table :solutions, :assignments
  end
end
