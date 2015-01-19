require 'spec_helper'

feature 'Login Flow' do
  scenario 'login from home' do
    visit '/'

    click_on 'Sign in with Github'

    expect(page).to have_text('testuser')
    expect(page).to have_text('Mumuki is a simple, open and collaborative platform')
  end

  scenario 'login from home, localized' do
    visit '/es'

    click_on 'Iniciá sesion con Github'

    expect(page).to have_text('testuser')
    expect(page).to have_text('Mumuki es una plataforma simple, abierta y colaborativa')
  end
end
