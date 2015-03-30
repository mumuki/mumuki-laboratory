class AddExpectationResultsToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :expectation_results, :text
  end
end
