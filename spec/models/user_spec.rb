require 'spec_helper'

describe User do

  describe '#recurrent?' do

    context 'when fresh new user' do
      let(:user) { create(:user) }
      it { expect(user.recurrent?).to be false }
    end

    context 'when already did a guide' do
      let(:exercise) { create(:exercise) }
      let(:user) { create(:user, last_exercise: exercise, last_organization: Organization.current) }

      it { expect(user.recurrent?).to be true }
    end

    context 'when already did a guide, but no org has being set' do
      let(:guide) { create(:guide) }
      let(:user) { create(:user, last_guide: guide) }

      it { expect(user.recurrent?).to be false }
    end
  end

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

    context 'when there are passed submissions' do
      let!(:assignment_for) do
        exercise_1.submit_solution!(user, content: '')
        exercise_1.submit_solution!(user, content: '').passed!
        exercise_2.submit_solution!(user, content: '').passed!
        exercise_3.submit_solution!(user, content: '')
      end

      it { expect(user.reload.last_submission_date).to eq Assignment.last.updated_at }
      it { expect(user.submitted_exercises_count).to eq 3 }
      it { expect(user.solved_exercises_count).to eq 2 }
      it { expect(user.submissions_count).to eq 4 }
      it { expect(user.passed_submissions_count).to eq 2 }
      it { expect(user.reload.last_exercise).to eq exercise_3 }
      it { expect(user.reload.last_guide).to eq exercise_3.guide }

    end


    context 'when there are only failed submissions' do
      let!(:exercise_4) { create(:exercise) }

      let!(:assignment_for) do
        exercise_4.submit_solution!(user, content: '').failed!
      end

      it { expect(user.reload.last_exercise).to eq exercise_4 }
      it { expect(user.reload.last_guide).to eq exercise_4.guide }
    end
  end
end
