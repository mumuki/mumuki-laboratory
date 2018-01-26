class AddExpectationResultsToSubmission < ActiveRecord::Migration[4.2]
  def change
    add_column :submissions, :expectation_results, :text
  end
end
