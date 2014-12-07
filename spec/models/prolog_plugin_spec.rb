require 'spec_helper'

TRUE_TEST = <<EOT
test(the_truth) :-
  assertion(true == true).
EOT

COMPILED_TRUE_TEST_SUBMISSION = <<EOT
:- begin_tests(mumuki_submission_test, []).
test(the_truth) :-
  assertion(true == true).


:- end_tests(mumuki_submission_test).
EOT

describe PrologPlugin do
  let(:plugin) { PrologPlugin.new }

  describe '#run_test_command' do
    let(:file) { OpenStruct.new(path: '/tmp/foo.pl') }
    it { expect(plugin.run_test_command(file)).to include('swipl -f /tmp/foo.pl --quiet -t run_tests') }
    it { expect(plugin.run_test_command(file)).to include('2>&1') }
  end

  describe '#compile' do
    let(:exercise) { create :exercise, language: :prolog, test: TRUE_TEST }
    let(:submission) { exercise.submissions.create content: '' }

    it { expect(submission.compile_with(plugin)).to eq(COMPILED_TRUE_TEST_SUBMISSION) }
  end

  describe '#run_test_file!' do
    let(:exercise) { create :exercise, language: :prolog, test: TRUE_TEST }
    let(:submission) { exercise.submissions.create content: '' }

    it 'fails when compilation is broken'
    it 'fails when test do not pass'
    it 'passes when test passes'
  end
end
