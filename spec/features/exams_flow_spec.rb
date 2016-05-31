require 'spec_helper'

feature 'Exams Flow' do
  let(:exam) { create(:exam, classroom_id: '12345') }
  let(:other_exam) { create(:exam, organization: other_organization) }

  let!(:chapter) {
    create(:chapter, lessons: [
        create(:lesson)]) }

  let(:other_organization) { create(:organization, name: 'baz') }

  before { reindex_current_organization! }

  scenario 'visit exam not in path, by id, anonymous' do
    expect { visit "/exams/#{other_exam.id}" }.to raise_error ActionController::RoutingError
  end

  scenario 'visit exam in path, by id, anonymous' do
    visit "/exams/#{exam.id}"

    expect(page).to have_text('You are not permitted to access this content')
  end

  scenario 'visit exam in path, by classroom id, anonymous' do
    visit "/exams/#{exam.classroom_id}"

    expect(page).to have_text('You are not permitted to access this content')
  end
end
