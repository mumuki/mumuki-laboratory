class Mumukit::Randomizer::Randomization::Range < Mumukit::Randomizer::Randomization::OneOf

  def initialize(lower_bound, upper_bound)
    @choices = (lower_bound..upper_bound).to_a
  end
end
