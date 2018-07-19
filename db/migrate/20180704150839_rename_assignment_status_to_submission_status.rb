class RenameAssignmentStatusToSubmissionStatus < ActiveRecord::Migration[5.1]
  def change
    rename_column :assignments, :status, :submission_status
  end
end
