require 'spec_helper'

feature 'Home Flow' do
  let!(:exercise) { build(:exercise) }
  let(:guide) { create(:guide) }
  let!(:chapter) {
    create(:chapter, lessons: [
        create(:lesson, guide: guide)]) }
  let(:book) { Organization.current.book }

  let(:user) { User.find_by(name: 'testuser') }

  before { reindex_current_book! }

  context 'anonymous visitor' do
    scenario 'from outside' do
      Capybara.current_session.driver.header 'Referer', 'http://google.com'

      visit '/'

      expect(page).to have_text('ム mumuki')
      expect(page).to have_text(Organization.current.book.name)
    end

    scenario 'from inside' do
      Capybara.current_session.driver.header 'Referer', 'http://en.mumuki.io/exercises/1'

      visit '/'

      expect(page).to have_text('ム mumuki')
      expect(page).to have_text(Organization.current.book.name)
    end
  end

  context 'new user' do
    before do
      visit '/'
      click_on 'Sign in'
    end

    scenario 'from outside' do
      Capybara.current_session.driver.header 'Referer', 'http://google.com'

      visit '/'

      expect(page).to have_text('ム mumuki')
      expect(page).to have_text(Organization.current.book.name)
    end


    scenario 'from inside' do
      Capybara.current_session.driver.header 'Referer', 'http://en.mumuki.io/exercises/1'

      visit '/'

      expect(page).to have_text('ム mumuki')
      expect(page).to have_text(Organization.current.book.name)
    end

  end

end
