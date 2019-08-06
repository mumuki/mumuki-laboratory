require 'spec_helper'

feature 'menu bar' do
  let(:chapter) { create(:chapter, lessons: [create(:lesson)]) }
  let(:book) { create(:book, chapters: [chapter], name: 'private', slug: 'mumuki/mumuki-the-private-book') }
  let(:private_organization) { create(:organization, name: 'private', book: book) }

  before { set_subdomain_host! private_organization.name }
  before { private_organization.switch! }

  context 'anonymous user' do
    context 'on organization without permissions' do
      scenario 'should not see menu bar' do
        OmniAuth.config.test_mode = false

        visit '/'

        expect(page).not_to have_text('Profile')
        expect(page).not_to have_text('Classroom')
        expect(page).not_to have_text('Bibliotheca')
      end
    end

    context 'on organization with permissions' do
      let(:public_organization) { create(:public_organization, book: book) }
      before { set_subdomain_host! public_organization.name }
      before { public_organization.switch! }

      scenario 'should not see menu bar' do
        OmniAuth.config.test_mode = false

        visit '/'

        expect(page).not_to have_text('Profile')
        expect(page).not_to have_text('Classroom')
        expect(page).not_to have_text('Bibliotheca')
      end
    end
  end

  context 'logged user' do
    let(:visitor) { create(:user) }
    let(:student) { create(:user, permissions: {student: 'private/*'}) }
    let(:teacher) { create(:user, permissions: {student: 'private/*', teacher: 'private/*'}) }
    let(:writer) { create(:user, permissions: {student: 'private/*', writer: 'private/*'}) }
    let(:janitor) { create(:user, permissions: {student: 'private/*', janitor: 'private/*'}) }
    let(:owner) { create(:user, permissions: {student: 'private/*', owner: 'private/*'}) }

    scenario 'visitor should only see profile' do
      set_current_user! visitor

      visit '/'
      expect(page).to have_text('Profile')
      expect(page).not_to have_text('Classroom')
      expect(page).not_to have_text('Bibliotheca')
    end

    scenario 'teacher should see profile and classroom' do
      set_current_user! teacher

      visit '/'

      expect(page).to have_text('Profile')
      expect(page).to have_text('Classroom')
      expect(page).not_to have_text('Bibliotheca')
    end

    scenario 'writer should see profile and bibliotheca' do
      set_current_user! writer

      visit '/'

      expect(page).to have_text('Profile')
      expect(page).not_to have_text('Classroom')
      expect(page).to have_text('Bibliotheca')
    end
  end
end
