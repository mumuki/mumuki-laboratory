module Mumukit
  class Randomizer
    def initialize(randomizations)
      @randomizations = randomizations
    end

    def with_seed(seed)
      @randomizations.each_with_index.map { |(key, value), index| [key, value.get(seed + index)] }
    end

    def randomize!(field, seed)
      with_seed(seed).inject(field) { |result, (replacee, replacer)| result.gsub "$#{replacee}", replacer.to_s }
    end

    def self.parse(randomizations)
      new randomizations.with_indifferent_access.transform_values { |it| Mumukit::Randomizer::Randomization.parse it }
    end
  end
end

require_relative 'randomizations/randomization'
require_relative 'randomizations/base'
require_relative 'randomizations/one_of'
require_relative 'randomizations/range'
