require 'capybara/rails'
require 'capybara/rspec'

# Test helpers

def set_subdomain_host!(subdomain)
  @request.try { |it| it.host = Mumukit::Platform.laboratory.organic_domain subdomain }
  Capybara.app_host = Mumukit::Platform.laboratory.organic_url subdomain
end

def set_implicit_central!
  warn "Implicit behaviour is going to be removed soon"
  @request.try { |it| it.host = Mumukit::Platform.laboratory.domain }
  Capybara.app_host = Mumukit::Platform.laboratory.url
end

# Config helpers

def selected_driver
  ENV['MUMUKI_CAPYBARA_DRIVER']&.to_sym || :rack_test
end

def run_with_selenium?
  selected_driver.to_s.start_with? 'selenium'
end

def register_safari_driver!
  # No official docs for this, code was taken from https://github.com/teamcapybara/capybara/blob/master/spec/selenium_spec_safari.rb
  if ::Selenium::WebDriver::Service.respond_to? :driver_path=
    ::Selenium::WebDriver::Safari::Service
  else
    ::Selenium::WebDriver::Safari
  end.driver_path = '/Applications/Safari Technology Preview.app/Contents/MacOS/safaridriver'

  Capybara.register_driver :selenium_safari do |app|
    Capybara::Selenium::Driver.new(app, browser: :safari, options: browser_options, timeout: 30)
  end
end

# Configuration

register_safari_driver! if selected_driver == :selenium_safari
Capybara.default_driver = selected_driver

if run_with_selenium?
  # TODO: fix the tests that depend on hidden elements and remove this
  Capybara.ignore_hidden_elements = false

  # Include port on the URL, so we don't need to forward it via nginx or so
  Capybara.always_include_port = true
end

puts "Running Capybara tests with #{selected_driver}, #{Capybara.ignore_hidden_elements ? '' : 'not '}ignoring hidden elements"
