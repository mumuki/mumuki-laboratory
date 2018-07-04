module Mumukit
  class Randomizer
    attr_accessor :randomizations

    def initialize(randomizations)
      @randomizations = randomizations
    end

    def with_seed(seed)
      acumulated_size = 1
      resulting_hash = {}

      randomizations.each do |key, value|
        resulting_hash.merge! key => value.get(seed / acumulated_size)
        acumulated_size += value.size - 1
      end
      resulting_hash
    end

    def randomize!(field, seed)
      with_seed(seed).inject(field) { |result, (replacee, replacer)| result.gsub "$#{replacee}", replacer }
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
