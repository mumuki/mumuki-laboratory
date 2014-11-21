class AddStatusToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :status, :integer, default: 0
  end
end
