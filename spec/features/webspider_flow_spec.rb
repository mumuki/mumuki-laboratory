require 'spec_helper'

Capybara.register_driver :rack_test do |app|
  Capybara::RackTest::Driver.new(app, :headers => { 'HTTP_ACCEPT_LANGUAGE' => nil })
end


feature 'Localized Pages' do
  scenario 'search from home, in spanish' do
    visit '/'

    expect(page).to have_link('Empezá a practicar!', href: '/es/exercises')
  end
end
