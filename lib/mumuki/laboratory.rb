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

require_relative './laboratory/version'
require_relative './laboratory/extensions'
require_relative './laboratory/controllers'
require_relative './laboratory/engine'
