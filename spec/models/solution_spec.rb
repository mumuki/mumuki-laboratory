require 'spec_helper'

describe Solution, organization_workspace: :test do

  let(:user) { create(:user) }

  describe '#try_submit_solution!' do

    context 'when on chapter' do
      let(:problem) { create(:problem) }
      let!(:chapter) {
        create(:chapter, name: 'Functional Programming', lessons: [
          create(:lesson, exercises: [problem])
        ]) }

      before { reindex_current_organization! }
      let!(:result) { problem.try_submit_solution! user }

      it { expect(result).to eq problem.find_assignment_for(user) }
      it { expect(result.attempts_left).to eq nil  }
      it { expect(result.attempts_left?).to be true  }
    end

    context 'when on exam' do
      let(:problem) { create(:problem) }
      let!(:exam) { create(:exam, max_problem_submissions: 10, exercises: [problem]) }

      before { reindex_current_organization! }
      let(:result) { problem.try_submit_solution! user }

      it { expect(result).to eq problem.find_assignment_for(user) }
      it { expect(result.attempts_left).to eq 9  }
      it { expect(result.attempts_left?).to be true  }
    end
  end

  describe '#submit_solution!' do

    before { expect_any_instance_of(Challenge).to receive(:automated_evaluation_class).and_return(Mumuki::Domain::Evaluation::Automated) }
    before { expect_any_instance_of(Language).to receive(:run_tests!).and_return(bridge_response) }

    context 'when results have no expectation' do
      let(:exercise) { create(:x_equal_5_exercise) }
      let(:assignment) { exercise.submit_solution! user }
      let(:bridge_response) { {result: '0 failures', status: :passed} }

      it { expect(assignment.status).to eq(:passed) }
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

      it { expect(assignment.status).to eq(:passed) }
      it { expect(assignment.result).to include('0 failures') }
      it { expect(assignment.expectation_results).to eq([{binding: 'foo', inspection: 'HasBinding', result: :passed}]) }
    end

  end
end
