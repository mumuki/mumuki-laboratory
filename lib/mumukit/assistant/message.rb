class Mumukit::Assistant::Message
  def initialize(alternatives)
    @alternatives = alternatives
  end

  def call(retries)
    @alternatives[alternative_number(retries) - 1]
  end

  def alternative_number(retries)
    [retries, @alternatives.size].compact.min
  end

  def self.parse(alternatives)
    alternatives = [alternatives] if alternatives.is_a? String
    new alternatives
  end
end