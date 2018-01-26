class ChangeSubmissionIdToString < ActiveRecord::Migration[4.2]
  def change
    change_column :comments, :submission_id, :string
  end
end
