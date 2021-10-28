require 'spec_helper'

feature 'not found public on app' do
  let!(:central) { create(:organization, name: 'central') }
  let!(:base) { create(:organization, name: 'base') }
  let!(:some_orga) { create(:public_organization, name: 'someorga', profile: profile) }

  let(:profile) { Mumuki::Domain::Organization::Profile.parse json  }
  let(:json) do
     {
      contact_email: 'some@email.com',
      locale: 'en',
      time_zone: 'Brasilia',
      errors_explanations: { "not_found" => 'Some explanation'}
    }
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

  scenario 'when organization has a customized error message' do
    set_subdomain_host! 'someorga'

    visit '/foo'

    expect(page).to have_text('Some explanation')
    expect(page).not_to have_text('You may have mistyped the address')
  end
end
