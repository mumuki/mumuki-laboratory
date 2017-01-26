require 'capybara/rails'
require 'capybara/rspec'

Capybara.app_host = "http://test.#{Rails.configuration.domain}"
Capybara.server_host = "test.#{Rails.configuration.domain}"
Capybara.server_port = '3000'

def set_subdomain_host!(subdomain)
  Capybara.app_host = "http://#{subdomain}.#{Rails.configuration.domain}"
end

def set_implicit_central!
  Capybara.app_host = "http://#{Rails.configuration.domain}"
end
