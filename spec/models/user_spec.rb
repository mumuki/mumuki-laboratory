require 'spec_helper'

describe User do

  describe '#submissions_count' do
    let!(:exercise_1) { create(:exercise) }
    let!(:exercise_2) { create(:exercise) }
    let!(:exercise_3) { create(:exercise) }

    let(:user) { create(:user) }
    context 'when there are no submissions' do
      it { expect(user.last_submission_date).to be nil }
      it { expect(user.submitted_exercises_count).to eq 0 }
      it { expect(user.solved_exercises_count).to eq 0 }
      it { expect(user.submissions_count).to eq 0 }
      it { expect(user.passed_submissions_count).to eq 0 }
    end

    context 'when there are submissions' do
      let!(:last_submission) do
        user.submissions.create!(exercise: exercise_1, status: :failed, content: '')
        user.submissions.create!(exercise: exercise_1, status: :passed, content: '')
        user.submissions.create!(exercise: exercise_2, status: :passed, content: '')
        user.submissions.create!(exercise: exercise_3, status: :failed, content: '')
      end

      it { expect(user.last_submission_date).to eq last_submission.reload.created_at }
      it { expect(user.submitted_exercises_count).to eq 3 }
      it { expect(user.solved_exercises_count).to eq 2 }
      it { expect(user.submissions_count).to eq 4 }
      it { expect(user.passed_submissions_count).to eq 2 }
    end
  end
end
