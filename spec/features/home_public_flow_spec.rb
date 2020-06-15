require 'spec_helper'

feature 'public org', organization_workspace: :test do
  let!(:exercise) { build(:exercise) }
  let(:guide) { create(:guide) }
  let(:exam) { create(:exam) }
  let!(:chapter_1) {
    create(:chapter, name: 'First Steps', number: 1, lessons: [
      create(:lesson, guide: guide)]) }
  let!(:chapter_2) {
      create(:chapter, name: 'Functional Programming', number: 2, lessons: [
        create(:lesson, guide: guide)]) }
  let!(:current_organization) { Organization.current }
  let(:book) { current_organization.book }

  before { reindex_current_organization! }

  context 'anonymous visitor' do
    scenario 'from outside' do
      Capybara.current_session.driver.header 'Referer', 'http://google.com'

      visit '/'

      expect(page).to have_text('ム mumuki')
      expect(page).to have_text('First Steps')
      expect(page).to have_selector('.chapter', text: 'Functional Programming')
      expect(page).to have_text(current_organization.book.name)
      expect(page).not_to have_text('Exams')
    end

    scenario 'from inside' do
      Capybara.current_session.driver.header 'Referer', 'http://en.mumuki.io/exercises/1'

      visit '/'

      expect(page).to have_text('ム mumuki')
      expect(page).to have_text('First Steps')
      expect(page).to have_selector('.chapter', text: 'Functional Programming')
      expect(page).to have_text(current_organization.book.name)
    end
  end

  context 'logged visitor' do
    let(:user) { create(:user) }
    before { set_current_user! user }
    before { exam.authorize! user }

    scenario 'from outside' do
      Capybara.current_session.driver.header 'Referer', 'http://google.com'

      visit '/'

      expect(page).to have_text('ム mumuki')
      expect(page).to have_text('First Steps')
      expect(page).to have_selector('.chapter', text: 'Functional Programming')
      expect(page).to have_text(current_organization.book.name)
      expect(user.reload.last_organization).to eq current_organization
      expect(page).to have_text('Exams')
    end

    scenario 'from inside' do
      Capybara.current_session.driver.header 'Referer', 'http://en.mumuki.io/exercises/1'

      visit '/'

      expect(page).to have_text('ム mumuki')
      expect(page).to have_text('First Steps')
      expect(page).to have_selector('.chapter', text: 'Functional Programming')
      expect(page).to_not have_selector('.chapter.mu-locked', text: 'Functional Programming')

      expect(page).to have_text(current_organization.book.name)
      expect(user.reload.last_organization).to eq current_organization
    end
  end

  context 'logged visitor in progressive display organization' do
    let(:user) { create(:user) }
    before { current_organization.enable_progressive_display! }
    before { set_current_user! user }
    before { exam.authorize! user }

    scenario 'from inside' do
      Capybara.current_session.driver.header 'Referer', 'http://google.com'

      visit '/'

      expect(page).to have_text('ム mumuki')
      expect(page).to have_text('First Steps')
      expect(page).to have_selector('.chapter.mu-locked', text: 'Functional Programming')
      expect(page).to have_text(current_organization.book.name)
      expect(user.reload.last_organization).to eq current_organization
    end
  end
end
