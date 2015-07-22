require 'spec_helper'

feature 'Home Flow' do
  let(:guide) { create(:guide) }
  let!(:exercise) { create(:exercise, id: 1, guide: guide) }
  let(:user) { User.find_by(name: 'testuser') }

  context 'anonymous visitor' do
    scenario 'from outside' do
      Capybara.current_session.driver.header 'Referer', 'http://google.com'

      visit '/'

      expect(page).to have_text('Mumuki is a simple, open and collaborative platform')
    end

    scenario 'from inside' do
      Capybara.current_session.driver.header 'Referer', 'http://en.mumuki.io/exercises/1'

      visit '/'

      expect(page).to have_text('Mumuki is a simple, open and collaborative platform')
    end
  end

  context 'new user' do
    before do
      visit '/'
      click_on 'Sign in with Github'
    end

    scenario 'from outside' do
      Capybara.current_session.driver.header 'Referer', 'http://google.com'

      visit '/'

      expect(page).to have_text('Mumuki is a simple, open and collaborative platform')
    end


    scenario 'from inside' do
      Capybara.current_session.driver.header 'Referer', 'http://en.mumuki.io/exercises/1'

      visit '/'

      expect(page).to have_text('Mumuki is a simple, open and collaborative platform')
    end

  end

  context 'recurrent user' do
    before do
      visit '/'
      click_on 'Sign in with Github'
      exercise.submit_solution(user, status: :passed)
    end

    scenario 'from outside' do
      Capybara.current_session.driver.header 'Referer', 'http://google.com'

      visit '/'

      expect(page).to_not have_text('Mumuki is a simple, open and collaborative platform')
      expect(page).to have_text(guide.name)
      expect(page).to have_text('Nice to see you again! This is where you left last time')
    end

    scenario 'logged recurrent user' do
      Capybara.current_session.driver.header 'Referer', 'http://en.mumuki.io/exercises/1'

      visit '/'

      expect(page).to have_text('Mumuki is a simple, open and collaborative platform')
    end
  end
end
