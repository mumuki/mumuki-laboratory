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
      @alternatives = alternatives
    end

    def call(retries)
      @alternatives[alternative_number(retries) - 1]
    end

    def alternative_number(retries)
      [retries, @alternatives.size].compact.min
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