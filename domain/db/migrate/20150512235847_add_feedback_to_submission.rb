class AddFeedbackToSubmission < ActiveRecord::Migration[4.2]
  def change
    add_column :submissions, :feedback, :text
  end
end
