require 'tempfile'

class TestRunner
  include SuckerPunch::Job

  def perform(submission_id)
    ActiveRecord::Base.connection_pool.with_connection do
      submission = ::Submission.find((submission_id))
      submission.update! status: :running

      compilation = submission.compile
      file = Tempfile.new('mumuki.compile')
      file.write(compilation)
      file.close

      result = %x{runhaskell #{file.path}}
      status = $?.success? ? :passed : :failed

      file.unlink
      submission.update! result: result, status: status
    end
  end

end