class OneOf
  attr_accessor :choices

  def initialize(choices)
    @choices = choices
  end

  def get(value)
    choices.to_a[value % choices.size]
  end
end
