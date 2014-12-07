require 'tempfile'

class TestRunnerJob
  include SuckerPunch::Job

  def perform(submission_id)
    ActiveRecord::Base.connection_pool.with_connection do
      submission = ::Submission.find(submission_id)
      submission.run_update! do
        plugin = submission.plugin
        compilation = plugin.compile(submission)
        file = create_compilation_file(submission, compilation)
        results = %x{#{plugin.run_command(file)}}, $?.success? ? :passed : :failed
        file.unlink
        results
      end
    end
  end


  def create_compilation_file(submission, compilation)
    file = Tempfile.new("mumuki.#{submission.language}.compile")
    file.write(compilation)
    file.close
    file
  end
end


class HaskellPlugin

  def compile(submission)
    _compile(submission.exercise.test, submission.content)
  end

  def run_command(file)
    "runhaskell #{file.path} 2>&1"
  end

  private

  def _compile(test_src, submission_src)
    <<EOF
import Test.Hspec
import Test.QuickCheck

#{submission_src}
main :: IO ()
main = hspec $ do
#{test_src}
EOF
  end

end

class PrologPlugin

  def compile(submission)
    _compile(submission.exercise.test, submission.content)
  end

  def run_command(file)
    "swipl -f #{file.path} --quiet -t run_tests 2>&1"
  end

  private

  def _compile(test_src, submission_src)
    <<EOF
:- begin_tests(mumki_submission_test, []).
#{test_src}
#{submission_src}
:- end_tests(mumki_submission_test).
EOF
  end

end