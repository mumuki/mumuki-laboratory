require 'tempfile'

class TestRunner
  include Sidekiq::Worker

  def perform(submission_id)
    submission = Submission.find((submission_id))
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