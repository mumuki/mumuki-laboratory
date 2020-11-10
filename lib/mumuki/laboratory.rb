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
require 'bootstrap-kaminari-views'

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

module Mumukit::Platform::OrganizationMapping::Path
  class << self
    patch :organization_name do |request, domain, hyper|
      name = hyper.(request, domain)
      if %w(auth login logout).include? name
        'base'
      else
        name
      end
    end
  end
end

require_relative './laboratory/version'
require_relative './laboratory/extensions'
require_relative './laboratory/controllers'
require_relative './laboratory/engine'
