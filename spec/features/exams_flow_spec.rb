require 'spec_helper'

feature 'Exams Flow', organization_workspace: :test do
  let(:exam) { create(:exam, classroom_id: '12345') }
  let(:other_exam) { create(:exam, organization: other_organization) }
  let!(:exam_not_in_path) { create :exam }

  let!(:chapter) {
    create(:chapter, lessons: [
        create(:lesson)]) }

  let(:other_organization) { create(:organization, name: 'baz') }

  before { reindex_current_organization! }

  context 'inexistent exam' do
    scenario 'visit exam by id, not in path' do
      visit "/exams/#{exam_not_in_path.id}"
      expect(page).to have_text('You have no permissions for this content. Maybe you logged in with another account.')
    end

    scenario 'visit exam by id, unknown exam' do
      visit '/exams/900000'
      expect(page).to have_text('You may have mistyped the address or the page may have moved')
    end
  end

  scenario 'visit exam not in path, by id, anonymous' do
   visit "/exams/#{other_exam.id}"
    expect(page).to have_text('You may have mistyped the address or the page may have moved')
  end

  scenario 'visit exam in path, by id, anonymous' do
    visit "/exams/#{exam.id}"

    expect(page).to have_text('You have no permissions for this content.')
  end

  scenario 'visit exam in path, by classroom id, anonymous' do
    visit "/exams/#{exam.classroom_id}"

    expect(page).to have_text('You have no permissions for this content.')
  end

  scenario 'visit exam in path, when there is no more time' do
    user = create(:user)
    set_current_user! user
    exam.authorize!(user)
    expect_any_instance_of(Exam).to receive(:enabled_for?).and_return(false)
    visit "/exams/#{exam.classroom_id}"

    expect(page).to have_text('This exam is no longer available.')
  end
end
