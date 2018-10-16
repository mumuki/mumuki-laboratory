class AddTestResultsToSubmission < ActiveRecord::Migration[4.2]
  def change
    add_column :submissions, :test_results, :text
  end
end
