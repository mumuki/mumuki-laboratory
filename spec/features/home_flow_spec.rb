require 'spec_helper'

feature 'Home Flow' do
  let!(:exercise) { create(:exercise, id: 1, guide: guide) }
  let(:guide) { create(:guide) }
  let(:chapter) { create(:chapter) }
  let(:book) { Organization.current.book }

  let(:user) { User.find_by(name: 'testuser') }

  before { chapter.rebuild!([guide]) }

  context 'anonymous visitor' do
    scenario 'from outside' do
      Capybara.current_session.driver.header 'Referer', 'http://google.com'

      visit '/'

      expect(page).to have_text('ム mumuki')
      expect(page).to have_text('Improve your programming skills')
    end

    scenario 'from inside' do
      Capybara.current_session.driver.header 'Referer', 'http://en.mumuki.io/exercises/1'

      visit '/'

      expect(page).to have_text('ム mumuki')
      expect(page).to have_text('Improve your programming skills')
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
      expect(page).to have_text('Improve your programming skills')
    end


    scenario 'from inside' do
      Capybara.current_session.driver.header 'Referer', 'http://en.mumuki.io/exercises/1'

      visit '/'

      expect(page).to have_text('ム mumuki')
      expect(page).to have_text('Improve your programming skills')
    end

  end

end
