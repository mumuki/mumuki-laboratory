require 'spec_helper'

describe User do
  describe '#clear_progress!' do
    let(:student) { create :user }
    let(:more_clauses) { create(:exercise, name: 'More Clauses') }

    before { more_clauses.submit_solution! student, content: 'foo(X) :- not(bar(X))' }

    before { student.reload.clear_progress! }

    it { expect(student.reload.assignments).to be_empty }
    it { expect(student.never_submitted?).to be true }
  end
  describe '#transfer_progress_to!' do

    let(:codeorga) { create :organization, name: 'Code.Orga' }
    let(:prologschool) { create :organization, name: 'PrologSchool' }

    let(:your_first_program) { create(:exercise, name: 'Your First Program') }
    let(:more_clauses) { create(:exercise, name: 'More Clauses') }

    let(:two_hours_ago) { 2.hours.ago }

    context 'when final user has less information than original' do
      let!(:submission) { your_first_program.submit_solution! original, content: 'adasdsadas' }

      before { original.reload.transfer_progress_to! final }

      let(:original) { create :user,
                              permissions: {student: 'codeorga/*'},
                              name: 'johnny doe',
                              social_id: 'auth0|123456',
                              last_organization: codeorga }

      let(:final) { create :user,
                           permissions: Mumukit::Auth::Permissions.new,
                           name: 'John Doe',
                           social_id: 'auth0|345678' }

      it { expect(final.name).to eq 'John Doe' }
      it { expect(final.social_id).to eq 'auth0|345678' }

      it { expect(final.last_submission_date).to eq original.last_submission_date }
      it { expect(final.last_organization).to eq codeorga }
      it { expect(final.last_exercise).to eq your_first_program }

      it { expect(final.permissions.as_json).to json_like({}) }

      it { expect(submission.reload.submitter).to eq final }
    end

    context 'when final user has more information than original' do
      before { more_clauses.submit_solution! final, content: 'adasdsadas' }
      before { original.transfer_progress_to! final.reload }

      let(:original) { create :user,
                              permissions: Mumukit::Auth::Permissions.new,
                              name: 'johnny doe',
                              social_id: 'auth0|123456' }
      let(:final) { create :user,
                           permissions: {student: 'prologschool/*'},
                           name: 'John Doe',
                           social_id: 'auth0|345678',
                           last_organization: prologschool }

      it { expect(final.name).to eq 'John Doe' }
      it { expect(final.social_id).to eq 'auth0|345678' }

      it { expect(final.last_submission_date).to_not be nil }
      it { expect(final.last_organization).to eq prologschool }
      it { expect(final.last_exercise).to eq more_clauses }

      it { expect(final.permissions.as_json).to json_like student: 'prologschool/*' }
    end

    context 'when both have information, but final is newer' do
      before { original.transfer_progress_to! final }

      let(:original) { create :user,
                              permissions: {student: 'codeorga/*'},
                              name: 'johnny doe',
                              social_id: 'auth0|123456',
                              last_submission_date: 6.hours.ago,
                              last_organization: codeorga,
                              last_exercise: your_first_program }
      let(:final) { create :user,
                           permissions: {student: 'prologschool/*'},
                           name: 'John Doe',
                           social_id: 'auth0|345678',
                           last_submission_date: two_hours_ago,
                           last_organization: prologschool,
                           last_exercise: more_clauses }

      it { expect(final.name).to eq 'John Doe' }
      it { expect(final.social_id).to eq 'auth0|345678' }

      it { expect(final.last_submission_date).to eq two_hours_ago }
      it { expect(final.last_organization).to eq prologschool }
      it { expect(final.last_exercise).to eq more_clauses }

      it { expect(final.permissions.as_json).to json_like student: 'prologschool/*' }
    end

    context 'when both have information, but original is newer' do
      before { original.transfer_progress_to! final }

      let(:original) { create :user,
                              permissions: {student: 'codeorga/*'},
                              name: 'johnny doe',
                              social_id: 'auth0|123456',
                              last_submission_date: two_hours_ago,
                              last_organization: codeorga,
                              last_exercise: your_first_program }
      let(:final) { create :user,
                           permissions: {student: 'prologschool/*'},
                           name: 'John Doe',
                           social_id: 'auth0|345678',
                           last_submission_date: 5.hours.ago,
                           last_organization: prologschool,
                           last_exercise: more_clauses }

      it { expect(final.name).to eq 'John Doe' }
      it { expect(final.social_id).to eq 'auth0|345678' }

      it { expect(final.last_submission_date).to eq two_hours_ago }
      it { expect(final.last_organization).to eq codeorga }
      it { expect(final.last_exercise).to eq your_first_program }

      it { expect(final.permissions.as_json).to json_like student: 'prologschool/*' }
    end
  end

  describe '#accessible_organizations' do
    before { create(:organization, name: 'pdep', book: create(:book, name: 'pdep', slug: 'mumuki/mumuki-the-pdep-book')) }
    let(:user) { create :user, permissions: permissions }

    context 'when one organizations' do
      let(:permissions) { {student: 'pdep/*'} }
      it { expect(user.accessible_organizations.size).to eq 1 }
    end
    context 'when two organizations' do
      let(:permissions) { {student: 'pdep/*:alcal/*'} }
      before { create(:organization, name: 'alcal', book: create(:book, name: 'alcal', slug: 'mumuki/mumuki-the-alcal-book')) }
      it { expect(user.accessible_organizations.size).to eq 2 }
    end
    context 'when all grant present organizations' do
      let(:permissions) { {student: 'pdep/*:*'} }
      it { expect(user.accessible_organizations.size).to eq 0 }
    end
    context 'when one organization appears twice' do
      let(:permissions) { {student: 'pdep/*:pdep/*'} }
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
    let(:user) { create :user, permissions: {student: 'pdep/k2001', teacher: 'test/all'} }

    it { expect(user.permissions.student? 'test/all').to be true }
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

  describe '#notify_changed!' do
    let(:user) { create(:user) }
    before { expect_any_instance_of(Mumukit::Nuntius::NotificationMode::Deaf).to receive(:notify_event!).exactly(2).times }
    it { expect { user.update! image_url: 'http://foo.com' }.to_not raise_error }
    it { expect { user.update! social_id: 'auth|foo' }.to_not raise_error }

  end
end
