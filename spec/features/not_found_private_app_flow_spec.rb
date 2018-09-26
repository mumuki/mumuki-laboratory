require 'spec_helper'

feature 'not found on app', organization_workspace: :base do
  before { set_subdomain_host! Organization.base.name }
  before { Organization.base.switch! }

  let(:owner) { create(:user, permissions: {owner: '*'}) }

  scenario 'without authentication' do
    visit '/nonexistentroute'

    expect(page).to have_text 'You are not allowed to see this content'

  end

  scenario 'with authentication' do
    set_current_user! owner

    visit '/nonexistentroute'

    expect(page).to have_text 'You may have mistyped the address or the page may have moved'
  end
end
