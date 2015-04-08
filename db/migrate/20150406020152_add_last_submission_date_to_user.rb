class AddLastSubmissionDateToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_submission_date, :datetime
  end
end
