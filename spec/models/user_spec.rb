require 'spec_helper'

describe User do
  describe '#accessible_organizations' do
    before { create(:organization, name: 'pdep', book: create(:book, name: 'pdep', slug: 'mumuki/mumuki-the-pdep-book')) }
    let(:user) { create :user }
    context 'when one organizations' do
      before { user.set_permissions! student: 'pdep/_' }
      it { expect(user.accessible_organizations.size).to eq 1}
    end
    context 'when two organizations' do
      before { user.set_permissions! student: 'pdep/_:alcal/_' }
      before { create(:organization, name: 'alcal', book: create(:book, name: 'alcal', slug: 'mumuki/mumuki-the-alcal-book')) }
      it { expect(user.accessible_organizations.size).to eq 2 }
    end
    context 'when all grant present organizations' do
      before { user.set_permissions! student: 'pdep/_:*' }
      it { expect(user.accessible_organizations.size).to eq 1 }
    end
    context 'when one organization appears twice' do
      before { user.set_permissions! student: 'pdep/_:pdep/_' }
      it { expect(user.accessible_organizations.size).to eq 1 }
    end
  end

  describe '#visit!' do
    let(:user) { create(:user) }

    before { user.visit! Organization.current }

    it { expect(user.last_organization).to eq Organization.current }
  end

  describe 'roles' do
    let(:other) { create(:organization, name: 'pdep') }
    let(:user) { create :user }
    before { user.set_permissions! student: 'pdep/k2001', teacher: 'test/all' }

    it { expect(user.permissions.student? 'test/all').to be false }
    it { expect(user.permissions.student? 'pdep/k2001').to be true }

    it { expect(user.permissions.teacher? 'test/all').to be true }
    it { expect(user.permissions.teacher? 'pdep/k2001').to be false }
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
        exercise_3.submit_solution!(user, content: '')
      end

      it { expect(user.reload.last_submission_date).to be > Assignment.last.created_at }
      it { expect(user.submitted_exercises_count).to eq 3 }
      it { expect(user.solved_exercises_count).to eq 2 }
      it { expect(user.submissions_count).to eq 5 }
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

  describe '#revoke!' do
    let(:user) { create(:user) }
    before { user.create_remember_me_token! }
    before { user.revoke! }

    it { expect(user.remember_me_token).to be_nil }
  end
end
