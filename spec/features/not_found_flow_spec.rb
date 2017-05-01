require 'spec_helper'

feature 'Choose organization Flow' do
  let!(:central) { create(:organization, name: 'central') }

  scenario 'when routes does not exist in implicit central' do
    visit '/foo'

    expect(page).to have_text('You may have mistyped the address')
  end

  scenario 'when route does not exist in explicit central' do
    set_subdomain_host! 'test'

    visit '/foo'

    expect(page).to have_text('You may have mistyped the address')
  end

  scenario 'when organization does not exist' do
    set_subdomain_host! 'foo'

    visit '/'

    expect(page).to have_text('You may have mistyped the address')
  end
end
