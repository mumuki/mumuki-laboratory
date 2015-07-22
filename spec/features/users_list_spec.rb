require 'spec_helper'

feature 'Users listing' do
  let!(:new_user) { create(:user, name: 'foobar') }
  let!(:user_with_submissions) { create(:user, name: 'baz') }
  let(:exercise) { create(:exercise) }

  before do
    exercise.submit_solution(user_with_submissions, status: :failed, content: '')
  end

  scenario 'list users' do
    visit '/'

    click_on 'Sign in with Github'

    visit '/users'

    expect(page).to have_text('foobar')
    expect(page).to have_text('baz')
  end

  scenario 'go to user from listing' do
    visit '/users'

    click_on 'foobar'

    expect(page).to have_text('foobar')
    expect(page).to have_text('Overview')
  end

end
