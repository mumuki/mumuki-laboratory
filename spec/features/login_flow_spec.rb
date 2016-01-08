require 'spec_helper'

feature 'Login Flow' do
  let!(:exercise) { create(:exercise) }

  scenario 'login from home', js: true do
    visit '/'

    click_on 'Sign in'

    expect(page).to have_text('testuser')
    expect(page).to have_text('Mumuki is a simple, open and collaborative platform')
  end

  scenario 'login on authentication request' do
    visit "/exercises/#{exercise.id}"

    expect(page).to have_text(exercise.name)

    click_on 'Sign in'
    expect(page).to have_text('Sign Out')
  end
end
