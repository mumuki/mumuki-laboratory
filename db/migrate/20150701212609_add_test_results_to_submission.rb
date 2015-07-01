class AddTestResultsToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :test_results, :text
  end
end
