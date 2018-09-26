require 'mumukit/platform'

Mumukit::Platform.configure do |config|
  # User class must understand
  #     find_by_uid!
  #     for_profile
  config.user_class_name = 'User'

  # Organization class must understand
  #     find_by_name!
  config.organization_class_name = 'Organization'

  config.application = Mumukit::Platform.laboratory
  config.web_framework = Mumukit::Platform::WebFramework::Rails
end

class Mumuki::Laboratory::Engine < ::Rails::Engine
  config.i18n.available_locales = Mumukit::Platform::Locale.supported
end

module Mumukit::Platform::OrganizationMapping::Subdomain
  class << self
    def path_under_namespace?(path, namespace)
      path.start_with? "/#{namespace}/"
    end
  end
end

module Mumukit::Platform::OrganizationMapping::Path
  class << self
    alias __organization_name__ organization_name

    def organization_name(request, domain)
      name = __organization_name__(request, domain)
      if %w(auth login logout).include? name
        'central'
      else
        name
      end
    end

    def path_under_namespace?(path, namespace)
      path.start_with? "/#{Mumukit::Platform.current_organization_name}/#{namespace}/"
    end
  end
end
