class AddFailedSubmissionsCountToAssignments < ActiveRecord::Migration[5.1]
  def change
    add_column :assignments, :attemps_count, :integer, default: 0
  end
end
