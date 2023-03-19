require 'mumukit/core'

I18n.load_translations_path File.join(__dir__, 'laboratory', 'locales', '*.yml')


module Mumuki
  module Laboratory
  end
end

require 'mumuki/domain'
require 'mumukit/login'
require 'mumukit/nuntius'
require 'mumukit/platform'

require 'kaminari'
require 'bootstrap5-kaminari-views'

Mumukit::Nuntius.configure do |config|
  config.app_name = 'laboratory'
end

Mumukit::Platform.configure do |config|
  config.application = Mumukit::Platform.laboratory
  config.web_framework = Mumukit::Platform::WebFramework::Rails
end

class Mumuki::Laboratory::Engine < ::Rails::Engine
  config.i18n.available_locales = Mumukit::Platform::Locale.supported
end

# module Mumukit::Platform::OrganizationMapping 
# end

module Mumukit::Platform::OrganizationMapping::Path
  class << self
    alias_method :__organization_name__, :organization_name
    def in_actual_organization?(request, domain = nil)
      actual_organization_name(request, domain).present?
    end

    def actual_organization_name(request, domain)
      name = __organization_name__(request, domain)
      name unless %w(auth login logout).include? name
    end

    def organization_name(request, domain)
      actual_organization_name(request, domain) || 'base'
    end

    patch :inorganic_path_for do |request, hyper|
      if in_actual_organization?(request)
        hyper.call(request)
      else
        path_for(request)
      end
    end
  end
end

require_relative './laboratory/version'
require_relative './laboratory/extensions'
require_relative './laboratory/controllers'
require_relative './laboratory/engine'
require_relative './laboratory/mailers/message_delivery'
