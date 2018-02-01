require 'spec_helper'

describe Solution do

  describe '#run_tests!' do
    let(:user) { create(:user) }

    before { expect_any_instance_of(Challenge).to receive(:automated_evaluation_class).and_return(AutomatedEvaluation) }
    before { expect_any_instance_of(Language).to receive(:run_tests!).and_return(bridge_response) }

    context 'when results have no expectation' do
      let(:exercise) { create(:x_equal_5_exercise) }
      let(:assignment) { exercise.submit_solution! user }
      let(:bridge_response) { {result: '0 failures', status: :passed} }

      it { expect(assignment.status).to eq(Mumuki::Laboratory::Status::Passed) }
      it { expect(assignment.result).to include('0 failures') }
    end

    context 'when results have expectations' do
      let(:exercise_with_expectations) {
        create(:x_equal_5_exercise, expectations: [{binding: :foo, inspection: :HasComposition}]) }
      let(:assignment) { exercise_with_expectations.submit_solution! user }
      let(:bridge_response) { {
          result: '0 failures',
          status: :passed,
          expectation_results: [binding: 'foo', inspection: 'HasBinding', result: :passed]} }

      it { expect(assignment.status).to eq(Mumuki::Laboratory::Status::Passed) }
      it { expect(assignment.result).to include('0 failures') }
      it { expect(assignment.expectation_results).to eq([{binding: 'foo', inspection: 'HasBinding', result: :passed}]) }
    end

  end
end
