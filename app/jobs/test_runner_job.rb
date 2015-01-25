class TestRunnerJob < ActiveRecordJob

  def perform_with_connection(submission_id)
    submission = ::Submission.find(submission_id)
    submission.run_tests! if submission.eligible_for_run?
  end
end
