class AddFailedSubmissionsCountToAssignments < ActiveRecord::Migration[5.1]
  def change
    add_column :assignments, :failed_submissions_count, :integer, default: 0
  end
end
