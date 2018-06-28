class Mumukit::Randomizer::Randomization::OneOf
  attr_accessor :choices

  def initialize(choices)
    @choices = choices
  end

  def size
    choices.size
  end

  def get(value)
    choices[value % size]
  end
end
