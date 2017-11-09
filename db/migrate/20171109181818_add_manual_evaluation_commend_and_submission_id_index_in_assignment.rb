class AddManualEvaluationCommendAndSubmissionIdIndexInAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :manual_evaluation_comment, :text, default: nil
    add_index :assignments, :submission_id
  end
end
