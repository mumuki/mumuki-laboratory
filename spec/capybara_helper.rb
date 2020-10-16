require 'capybara/rails'
require 'capybara/rspec'

def selected_driver
  ENV['MUMUKI_CAPYBARA_DRIVER']&.to_sym || :rack_test
end

def run_with_selenium?
  selected_driver.to_s.start_with? 'selenium'
end

Capybara.default_driver = selected_driver

if run_with_selenium?
  # TODO: fix the tests that depend on hidden elements and remove this
  Capybara.ignore_hidden_elements = false

  # Include port on the URL, so we don't need to forward it via nginx or so
  Capybara.always_include_port = true
end

puts "Running Capybara tests with #{selected_driver}, #{Capybara.ignore_hidden_elements ? '' : 'not '}ignoring hidden elements"

def set_subdomain_host!(subdomain)
  @request.try { |it| it.host = Mumukit::Platform.laboratory.organic_domain subdomain }
  Capybara.app_host = Mumukit::Platform.laboratory.organic_url subdomain
end

def set_implicit_central!
  warn "Implicit behaviour is going to be removed soon"
  @request.try { |it| it.host = Mumukit::Platform.laboratory.domain }
  Capybara.app_host = Mumukit::Platform.laboratory.url
end
