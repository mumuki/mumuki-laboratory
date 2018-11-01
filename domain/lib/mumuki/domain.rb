require "mumuki/domain/engine"

I18n.load_translations_path File.join(__dir__, 'domain', 'locales', '*.yml')

module Mumuki
  module Domain
  end
end

require_relative './domain/evaluation'
require_relative './domain/submission'
require_relative './domain/status'
require_relative './domain/exceptions'
require_relative './domain/file'
require_relative './domain/extensions'

require_relative './domain/mumukit/platform'


class Mumukit::Assistant
  def self.valid?(rules)
    !!parse(rules.map(&:deep_symbolize_keys)) rescue false
  end
end

class Mumukit::Expectation
  def self.valid?(expectation)
    !!Mumukit::Inspection.parse(expectation['inspection']) rescue false
  end
end

class Mumukit::Randomizer
  def self.valid?(randomizations)
    !!parse(randomizations) rescue false
  end
end
