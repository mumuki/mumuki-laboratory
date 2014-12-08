require 'spec_helper'

describe PrologPlugin do
  true_test = <<EOT
test(the_truth) :-
  assertion(true == true).
EOT

  compiled_test_submission = <<EOT
:- begin_tests(mumuki_submission_test, []).
test(the_truth) :-
  assertion(true == true).


:- end_tests(mumuki_submission_test).
EOT

  let(:plugin) { PrologPlugin.new }
  let(:file) { OpenStruct.new(path: '/tmp/foo.pl') }

  describe '#run_test_command' do
    it { expect(plugin.run_test_command(file)).to include('swipl -f /tmp/foo.pl --quiet -t run_tests') }
    it { expect(plugin.run_test_command(file)).to include('2>&1') }
  end

  describe '#compile' do
    let(:exercise) { create :exercise, language: :prolog, test: true_test }
    let(:submission) { exercise.submissions.create content: '' }

    it { expect(submission.compile_with(plugin)).to eq(compiled_test_submission) }
  end

  describe '#validate_compile_errors' do
    let(:results) { plugin.validate_compile_errors(file, *original_results) }

    describe 'fails on test errors' do
      let(:original_results) { ['Test failed', :failed] }
      it { expect(results).to eq(original_results) }
    end

    describe 'fails on compile errors ' do
      let(:original_results) { ['ERROR: /tmp/foo.pl:3:0: Syntax error: Operator expected', :passed] }
      it { expect(results).to eq(['ERROR: /tmp/foo.pl:3:0: Syntax error: Operator expected', :failed]) }
    end

    describe 'passes otherwise' do
      let(:original_results) { ['....', :passed] }
      it { expect(results).to eq(['....', :passed]) }
    end
  end
end
