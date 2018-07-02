module Mumukit::Randomizer::Randomization
  attr_accessor :randomizations

  def initialize(randomizations)
    @randomizations = randomizations
  end

  def self.parse(randomization)
    case randomization[:type].to_sym
      when :oneOf then Mumukit::Randomizer::Randomization::OneOf.new randomization[:value]
      when :range then Mumukit::Randomizer::Randomization::Range.new(*randomization[:value])
      else raise 'Unsupported randomization kind'
    end
  end
end
