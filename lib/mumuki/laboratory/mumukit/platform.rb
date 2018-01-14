require 'mumukit/platform'

Mumukit::Platform.configure do |config|
  config.application = Mumukit::Platform.laboratory
  config.web_framework = Mumukit::Platform::WebFramework::Rails
end

module Mumukit::Platform::OrganizationMapping::Path
  class << self
    alias __organization_name__ organization_name

    def organization_name(request, domain)
      puts "'Getting org name for' #{request} #{domain}"
      name = __organization_name__(request, domain)
      if %w(auth login logout).include? name
        'central'
      else
        name
      end
    end
  end
end

class Mumukit::Platform::Organization::Settings < Mumukit::Platform::Model
  def login_settings
    @login_settings ||= Mumukit::Login::Settings.new(login_methods)
  end

  def customized_login_methods?
    login_methods.size < Mumukit::Login::Settings.login_methods.size
  end

  def inconsistent_public_login?
    customized_login_methods? && public?
  end
end


