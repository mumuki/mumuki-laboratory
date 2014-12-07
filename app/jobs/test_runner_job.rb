require 'tempfile'

class TestRunnerJob
  include SuckerPunch::Job

  def perform(submission_id)
    ActiveRecord::Base.connection_pool.with_connection do
      ::Submission.find(submission_id).run_tests!
    end
  end
end