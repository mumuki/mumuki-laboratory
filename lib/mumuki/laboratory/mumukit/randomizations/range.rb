class Mumukit::Randomizer::Randomization::Range < Mumukit::Randomizer::Randomization::Base
  def initialize(lower_bound, upper_bound)
    @choices = Range.new lower_bound, upper_bound
  end

  def get(value)
    modulo(value, choices.first..choices.last)
  end
end
