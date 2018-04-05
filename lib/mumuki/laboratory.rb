require 'mumukit/core'

I18n.load_translations_path File.join(__dir__, 'laboratory', 'locales', '*.yml')

require 'mumuki/laboratory/engine'

module Mumuki
  module Laboratory
  end
end

require 'mumukit/inspection'
require 'mumukit/bridge'
require 'mumukit/content_type'

require_relative './laboratory/mumukit/auth'
require_relative './laboratory/mumukit/directives'
require_relative './laboratory/mumukit/login'
require_relative './laboratory/mumukit/nuntius'
require_relative './laboratory/mumukit/platform'

require_relative './laboratory/extensions'
require_relative './laboratory/exceptions'
require_relative './laboratory/status'
require_relative './laboratory/evaluation'
require_relative './laboratory/controllers'
