require 'spec_helper'

describe User do

  describe '#submissions_count' do
    let!(:exercise_1) { create(:exercise) }
    let!(:exercise_2) { create(:exercise) }
    let!(:exercise_3) { create(:exercise) }

    let(:user) { create(:user) }
    context 'when there are no submissions' do
      it { expect(user.reload.last_submission_date).to be nil }
      it { expect(user.submitted_exercises_count).to eq 0 }
      it { expect(user.solved_exercises_count).to eq 0 }
      it { expect(user.submissions_count).to eq 0 }
      it { expect(user.passed_submissions_count).to eq 0 }
      it { expect(user.reload.last_exercise).to be_nil }
      it { expect(user.reload.last_guide).to be_nil }
    end

    context 'when there are submissions from orphan exercise' do
      let!(:solution_for) do
        exercise_1.submit_solution(user, status: :failed, content: '')
        exercise_1.submit_solution(user, status: :passed, content: '')
        exercise_2.submit_solution(user, status: :passed, content: '')
        exercise_3.submit_solution(user, status: :failed, content: '')
      end

      it { expect(user.reload.last_submission_date).to eq Solution.last.updated_at }
      it { expect(user.submitted_exercises_count).to eq 3 }
      it { expect(user.solved_exercises_count).to eq 2 }
      it { expect(user.submissions_count).to eq 4 }
      it { expect(user.passed_submissions_count).to eq 2 }
      it { expect(user.reload.last_exercise).to eq exercise_3 }
      it { expect(user.reload.last_guide).to be_nil }
    end


    context 'when there are submissions from a non orphan guide' do
      let(:guide) { create(:guide) }
      let!(:exercise_4) { create(:exercise, guide: guide) }

      let!(:solution_for) do
        exercise_4.submit_solution(user, status: :failed, content: '')
      end

      it { expect(user.reload.last_exercise).to eq exercise_4 }
      it { expect(user.reload.last_guide).to eq guide }
    end
  end
end
