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