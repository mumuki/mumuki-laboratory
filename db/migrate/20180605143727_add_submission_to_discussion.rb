class AddSubmissionToDiscussion < ActiveRecord::Migration[5.1]
  def change
    change_table :discussions do |t|
      t.text "solution"
      t.integer "submission_status", default: 0
      t.text "result"
      t.text "expectation_results"
      t.text "feedback"
      t.text "test_results"
      t.string "submission_id"
      t.string "queries", default: [], array: true
      t.text "query_results"
      t.text "manual_evaluation_comment"
    end
  end
end
