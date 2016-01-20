require 'spec_helper'

feature 'Home Flow' do
  let(:guide) { create(:guide) }
  let!(:exercise) { create(:exercise, id: 1, guide: guide) }
  let(:user) { User.find_by(name: 'testuser') }
  let(:chapter) { create(:chapter) }

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
