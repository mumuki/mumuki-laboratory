require 'spec_helper'

feature 'private org' do
  let(:private_organization) do
    create(:organization,
           name: 'private',
           public: false,
           book: create(:book, name: 'private', slug: 'mumuki/mumuki-the-private-book'))
  end

  before { set_subdomain_host! private_organization.name }
  before { private_organization.switch! }

  let!(:chapter) {
    create(:chapter, name: 'Functional Programming', lessons: [
      create(:lesson, name: 'getting-started', description: 'An awesome guide', exercises: [
        build(:exercise), build(:exercise), build(:exercise)
      ])
    ]) }

  let!(:current_organization) { Organization.current }

  before { reindex_current_organization! }


  context 'anonymous user' do
    scenario 'should not access' do
      visit '/'

      expect(page).not_to have_text('Nobody created a guide for this search yet')
    end
    scenario 'should have access' do
      visit '/join/1234'

      expect(page).not_to have_text('You are not allowed to see this content')
    end
  end

  context 'logged user' do
    let(:visitor) { create(:user) }
    let(:student) { create(:user, permissions: {student: 'private/*'}) }
    let(:teacher) { create(:user, permissions: {student: 'private/*', teacher: 'private/*'}) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:from_sessions?).and_return(false)
    end

    scenario 'visitor should raise forbidden error' do
      set_current_user! visitor

      visit '/'
      expect(page).to have_text('You are not allowed to see this content')
      expect(visitor.reload.last_organization).to be nil
    end

    scenario 'student should access' do
      set_current_user! student

      visit '/'

      expect(student.reload.last_organization).to eq current_organization
      expect(page).to have_text('powered by mumuki')
      expect(page).to have_text(current_organization.description)
      expect(page).to have_text(current_organization.book.description)
    end

    scenario 'teacher should access' do
      set_current_user! teacher

      visit '/'

      expect(teacher.reload.last_organization).to eq current_organization
      expect(page).to have_text('powered by mumuki')
      expect(page).to have_text(current_organization.description)
      expect(page).to have_text(current_organization.book.description)
    end
  end
end
