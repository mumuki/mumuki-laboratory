require 'spec_helper'

describe WithTestRunning do

  describe '#run_tests!' do
    let(:exercise) { create(:x_equal_5_exercise) }
    let(:exercise_with_expectations) {
      create(:x_equal_5_exercise, expectations: [{binding: :foo, inspection: :HasComposition}]) }
    let(:user) { exercise.author }

    before { expect_any_instance_of(Language).to receive(:run_tests!).and_return(bridge_response) }
    before { solution.run_tests! }

    context 'when results have no expectation' do
      let(:solution) { create(:solution, exercise: exercise) }
      let(:bridge_response) { {result: '0 failures', status: :passed} }

      it { expect(solution.reload.status).to eq(Status::Passed) }
      it { expect(solution.reload.result).to include('0 failures') }
    end

    context 'when results have expectations' do
      let(:solution) { create(:solution, exercise: exercise_with_expectations) }
      let(:bridge_response) { {
          result: '0 failures',
          status: :passed,
          expectation_results: [binding: 'foo', inspection: 'HasBinding', result: :passed]} }

      it { expect(solution.reload.status).to eq(Status::Passed) }
      it { expect(solution.reload.result).to include('0 failures') }
      it { expect(solution.reload.expectation_results).to eq([{binding: 'foo', inspection: 'HasBinding', result: :passed}]) }
    end

  end
end
