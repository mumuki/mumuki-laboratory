require 'spec_helper'

describe WithTestRunning do

  describe '#run_tests!' do
    let(:exercise) { create(:x_equal_5_exercise) }
    let(:exercise_with_expectations) {
      create(:x_equal_5_exercise, expectations: [{binding: :foo, inspection: :HasComposition}]) }
    let(:user) { exercise.author }

    before { expect_any_instance_of(Language).to receive(:run_tests!).and_return(bridge_response) }
    before { assignment.run_tests! }

    context 'when results have no expectation' do
      let(:assignment) { create(:assignment, exercise: exercise) }
      let(:bridge_response) { {result: '0 failures', status: :passed} }

      it { expect(assignment.reload.status).to eq(Status::Passed) }
      it { expect(assignment.reload.result).to include('0 failures') }
    end

    context 'when results have expectations' do
      let(:assignment) { create(:assignment, exercise: exercise_with_expectations) }
      let(:bridge_response) { {
          result: '0 failures',
          status: :passed,
          expectation_results: [binding: 'foo', inspection: 'HasBinding', result: :passed]} }

      it { expect(assignment.reload.status).to eq(Status::Passed) }
      it { expect(assignment.reload.result).to include('0 failures') }
      it { expect(assignment.reload.expectation_results).to eq([{binding: 'foo', inspection: 'HasBinding', result: :passed}]) }
    end

  end
end
