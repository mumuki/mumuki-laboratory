require 'spec_helper'

feature 'Create guide flow' do
  let(:user) { User.first }

  scenario 'create guide' do
    visit '/'

    click_on 'Sign in with Github'

    visit "/users/#{user.id}/guides"

    click_on 'New Guide'

    fill_in 'url', with: 'http://content.mumuki.io/d6af7358e195e8be'

    click_on 'Create Guide'

    expect(page).to have_text('Guide created successfully')

    expect(page).to have_text('Import/Export')
    expect(page).to have_text('Info')
    expect(page).to have_text('Basic')
  end


end
