class Mumukit::Randomizer::Randomization::OneOf < Mumukit::Randomizer::Randomization::Base
  def initialize(choices)
    @choices = choices
  end

  def get(value)
    choices[modulo(value, 0..choices.size - 1)]
  end
end
