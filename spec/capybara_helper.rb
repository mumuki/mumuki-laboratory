require 'capybara/rails'
require 'capybara/rspec'

def set_subdomain_host!(subdomain)
  @request.try { |it| it.host = Mumukit::Platform.application.organic_domain subdomain }
  Capybara.app_host = Mumukit::Platform.application.organic_url subdomain
end

def set_implicit_central!
  @request.try { |it| it.host = Mumukit::Platform.application.domain }
  Capybara.app_host = Mumukit::Platform.application.url
end
