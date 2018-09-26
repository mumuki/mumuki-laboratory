require 'spec_helper'

feature 'not found on app', organization_workspace: :base do
  before { set_subdomain_host! Organization.base.name }
  before { Organization.base.switch! }

  let(:owner) { create(:user, permissions: {owner: '*'}) }
  let(:student_api_client) { create :api_client, role: :student, grant: 'central/*' }
  let(:owner_api_client) { create :api_client, role: :owner, grant: '*' }

  scenario 'app without authentication' do
    visit '/nonexistentroute'

    expect(page).to have_text 'You are not allowed to see this content'
  end

  scenario 'app with authentication' do
    set_current_user! owner

    visit '/nonexistentroute'

    expect(page).to have_text 'You may have mistyped the address or the page may have moved'
  end

  scenario 'api without authorization' do
    Capybara.current_session.driver.header 'Authorization', "Bearer #{student_api_client.token}"

    visit '/api/nonexistentroute'

    expect(page.text).to json_eq errors: [
      'Access to organization base' +
      ' was forbidden to user foo+1@bar.com' +
      ' with permissions {"student":"central/*","teacher":"","headmaster":"","janitor":"","owner":""}']
  end

  scenario 'api with authentication' do
    Capybara.current_session.driver.header 'Authorization', "Bearer #{owner_api_client.token}"

    visit '/api/nonexistentroute'

    expect(page.text).to json_eq errors: ['not found']
  end
end
