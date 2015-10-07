class RenameAssignmentContentToSolution < ActiveRecord::Migration
  def change
    rename_column :assignments, :content, :solution
  end
end
