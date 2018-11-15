class RenameAssignmentContentToSolution < ActiveRecord::Migration[4.2]
  def change
    rename_column :assignments, :content, :solution
  end
end
