class AddLastSubmissionDateToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :last_submission_date, :datetime
  end
end
