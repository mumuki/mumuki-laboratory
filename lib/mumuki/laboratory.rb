require 'mumukit/core'

I18n.load_translations_path File.join(__dir__, 'laboratory', 'locales', '*.yml')

module Mumuki
  module Laboratory
  end
end

require 'mumukit/inspection'
require 'mumukit/content_type'

require_relative './laboratory/mumukit/auth'
require_relative './laboratory/mumukit/directives'
require_relative './laboratory/mumukit/login'
require_relative './laboratory/mumukit/nuntius'
require_relative './laboratory/mumukit/platform'

require_relative './laboratory/extensions'
require_relative './laboratory/exceptions'
