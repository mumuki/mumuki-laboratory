require 'spec_helper'

feature 'Create guide flow' do
  let(:user) { User.first }

  scenario 'create guide' do
    visit '/'

    click_on 'Sign in with Github'

    visit "/users/#{user.id}/guides"

    click_on 'New Guide'

    fill_in 'guide_slug', with: 'mumuki/mumuki-guia-funcional-0'

    click_on 'Create Guide'

    expect(page).to have_text('Guide created successfully')
  end


end
