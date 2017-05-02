Mumukit::Platform.configure do |config|
  config.application = Mumukit::Platform.laboratory
  config.web_framework = Mumukit::Platform::WebFramework::Rails
end

module Mumukit::Platform::OrganizationMapping::Path
  class << self
    alias_method :__organization_name__, :organization_name

    def organization_name(request, domain)
      name = __organization_name__(request, domain)
      if %w(auth login logout).include? name
        'central'
      else
        name
      end
    end
  end
end
