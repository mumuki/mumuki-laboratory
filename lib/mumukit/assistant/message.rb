module Mumukit::Assistant::Message
  class Fixed
    def initialize(text)
      @text = text
    end

    def call(_)
      @text
    end
  end

  class Progressive
    def initialize(alternatives)
      raise 'You need at least two alternatives' if alternatives.size < 2
      @alternatives = alternatives
    end

    def call(attemps_count)
      case attemps_count
      when (1..3) then @alternatives.first
      when (4..6) then @alternatives.second
      else @alternatives.last
      end
    end
  end

  def self.parse(text_or_alternatives)
    if text_or_alternatives.is_a? String
      Fixed.new text_or_alternatives
    else
      Progressive.new text_or_alternatives
    end
  end
end