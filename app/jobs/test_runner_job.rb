require 'tempfile'

class TestRunnerJob
  include SuckerPunch::Job

  def perform_with(submission)
    submission.run_update! do
      plugin = submission.plugin
      compilation = submission.compile_with(plugin)
      file = submission.create_compilation_file!(compilation)
      results = plugin.run_test_file!(file)
      file.unlink
      results
    end
  end

  def perform(submission_id)
    ActiveRecord::Base.connection_pool.with_connection do
      perform_with(::Submission.find(submission_id))
    end
  end
end

class BasePlugin
  def run_test_file!(file)
    [%x{#{run_test_command(file)}}, $?.success? ? :passed : :failed]
  end
end

class HaskellPlugin < BasePlugin

  def run_test_command(file)
    "runhaskell #{file.path} 2>&1"
  end

  def compile(test_src, submission_src)
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

class PrologPlugin < BasePlugin

  def run_test_file!(file)
    validate_compile_errors(file, *super)
  end

  def validate_compile_errors(file, result, status)
    if /ERROR: #{file.path}:.*: Syntax error: .*/ =~ result
      [result, :failed]
    else
      [result, status]
    end
  end

  def run_test_command(file)
    "swipl -f #{file.path} --quiet -t run_tests 2>&1"
  end

  def compile(test_src, submission_src)
    <<EOF
:- begin_tests(mumuki_submission_test, []).
#{test_src}
#{submission_src}
:- end_tests(mumuki_submission_test).
EOF
  end

end