require 'spec_helper'

describe Assignment do

  describe '#results_visible?' do
    let(:gobstones) { create(:language, visible_success_output: true) }
    let(:gobstones_exercise) { create(:exercise, language: gobstones) }

    let(:failed_submission) { create(:assignment, status: :failed) }
    let(:passed_submission) { create(:assignment, status: :passed, expectation_results: []) }
    let(:passed_submission_with_visible_output_language) { create(:assignment, status: :passed, exercise: gobstones_exercise) }

    it { expect(passed_submission.results_visible?).to be false }
    it { expect(failed_submission.should_retry?).to be true }
    it { expect(failed_submission.results_visible?).to be true }
    it { expect(passed_submission_with_visible_output_language.results_visible?).to be true }
  end
  describe '#run_update!' do
    let(:assignment) { create(:assignment) }
    context 'when run passes unstructured' do
      before { assignment.run_update! { {result: 'ok', status: :passed} } }
      it { expect(assignment.status).to eq(Status::Passed) }
      it { expect(assignment.result).to eq('ok') }
    end

    context 'when run fails unstructured' do
      before { assignment.run_update! { {result: 'ups', status: :failed} } }
      it { expect(assignment.status).to eq(Status::Failed) }
      it { expect(assignment.result).to eq('ups') }
    end

    context 'when run aborts unstructured' do
      before { assignment.run_update! { {result: 'took more thn 4 seconds', status: :aborted} } }
      it { expect(assignment.status).to eq(Status::Aborted) }
      it { expect(assignment.result).to eq('took more thn 4 seconds') }
    end

    context 'when run passes with warnings unstructured' do
      let(:runner_response) do
        {status: :passed_with_warnings,
         test_results: [{title: 'true is true', status: :passed, result: ''},
                        {title: 'false is false', status: :passed, result: ''}],
         expectation_results: [{binding: 'bar', inspection: 'HasBinding', result: :passed},
                               {binding: 'foo', inspection: 'HasBinding', result: :failed}],
         feedback: 'foo'}
      end
      before { assignment.run_update! { runner_response } }

      it { expect(assignment.status).to eq(Status::PassedWithWarnings) }
      it { expect(assignment.result).to be_blank }
      it { expect(assignment.test_results).to eq(runner_response[:test_results]) }
      it { expect(assignment.expectation_results).to eq(runner_response[:expectation_results]) }
      it { expect(assignment.feedback).to eq('foo') }
    end
    context 'when run raises exception' do
      before do
        begin
          assignment.run_update! { raise 'ouch' }
        rescue
        end
      end
      it { expect(assignment.status).to eq(Status::Errored) }
      it { expect(assignment.result).to eq('ouch') }
    end
  end

  describe '#update_submissions_count!' do
    let(:exercise) { create(:exercise) }
    let(:user) { create(:user) }

    before do
      exercise.submit_solution!(user)
      exercise.submit_solution!(user)
      exercise.submit_solution!(user)
    end

    it { expect(exercise.reload.submissions_count).to eq(3) }
  end

  describe '#submission_id' do
    let(:exercise) { create(:exercise) }
    let(:user) { create(:user) }

    before {  exercise.submit_solution!(user, content: 'foo') }

    it do
      submission_id = exercise.assignment_for(user).submission_id
      expect(submission_id).to be_present

      exercise.submit_solution!(user, content: 'bar')

      new_submission_id = exercise.assignment_for(user).submission_id
      expect(new_submission_id).to be_present
      expect(new_submission_id).to_not eq submission_id
    end
  end

end
