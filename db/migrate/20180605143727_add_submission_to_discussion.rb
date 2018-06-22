class AddSubmissionToDiscussion < ActiveRecord::Migration[5.1]
  def change
    change_table :discussions do |t|
      t.text :solution
      t.text :feedback
      t.text :result
      t.integer :submission_status
      t.text :test_results
      t.text :expectation_results
    end
  end
end
