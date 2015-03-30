require 'spec_helper'

describe TestRunning do

  describe '#run_tests!' do
    let(:exercise) { create(:x_equal_5_exercise) }
    let(:exercise_with_expectations) { create(:x_equal_5_exercise, expectations: [
        Expectation.new(binding: :foo, inspection: :HasComposition)]) }
    let(:user) { exercise.author }

    before { expect(submission.language).to receive(:post_to_server).and_return(server_response) }
    before { submission.run_tests! }

    context 'when submission is ok' do
      let(:submission) { create(:submission, exercise: exercise) }
      let(:server_response) { {'out' => '0 failures','exit' => 'passed'} }

      it { expect(submission.reload.status).to eq('passed') }
      it { expect(submission.reload.result).to include('0 failures') }
    end

    context 'when submission is ok and has expectations' do
      let(:submission) { create(:submission, exercise: exercise_with_expectations) }
      let(:server_response) { {
          'out' => '0 failures',
          'exit' => 'passed',
          'expectationResults' => [{
              'expectation' => {
                  'binding'=> 'foo',
                  'inspection' => 'HasBinding'},
              'result' => true
          }]} }

      it { expect(submission.reload.status).to eq('passed') }
      it { expect(submission.reload.result).to include('0 failures') }
      it { expect(submission.reload.expectation_results).to eq([{binding: 'foo', inspection: 'HasBinding', result: :passed}]) }

    end

    context 'when submission is not ok' do
      let(:submission) { create(:submission, exercise: exercise)}
      let(:server_response) { {'out' => 'should be equal 5 FAILED', 'exit' => 'failed'} }

      it { expect(submission.reload.status).to eq('failed') }
      it { expect(submission.reload.result).to include('should be equal 5 FAILED') }
    end

  end
end
