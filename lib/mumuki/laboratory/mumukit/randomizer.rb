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

    def self.parse(randomizations)
      new randomizations.transform_values { |it| Mumukit::Randomizer::Randomization.parse it }
    end
  end
end

require_relative 'randomizations/randomization'
require_relative 'randomizations/base'
require_relative 'randomizations/one_of'
require_relative 'randomizations/range'
require_relative 'randomizations/with_randomizations'
