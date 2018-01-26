class AddStatusToSubmission < ActiveRecord::Migration[4.2]
  def change
    add_column :submissions, :status, :integer, default: 0
  end
end
