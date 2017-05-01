require 'capybara/rails'
require 'capybara/rspec'

Capybara.app_host = Mumukit::Platform.application.organic_url 'test'

def set_subdomain_host!(subdomain)
  Capybara.app_host = Mumukit::Platform.application.organic_url subdomain
end

def set_implicit_central!
  Capybara.app_host = Mumukit::Platform.application.url
end
