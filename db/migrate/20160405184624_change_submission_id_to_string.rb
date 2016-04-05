class ChangeSubmissionIdToString < ActiveRecord::Migration
  def change
    change_column :comments, :submission_id, :string
  end
end
