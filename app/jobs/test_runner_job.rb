class TestRunnerJob < ActiveRecordJob

  def perform_with_connection(submission_id)
    ::Submission.find(submission_id).run_tests!
  end
end