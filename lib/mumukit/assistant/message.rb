module Mumukit::Assistant::Message
  # Fixed messages are independent of the number
  # of attemps
  class Fixed
    def initialize(text)
      @text = text
    end

    def call(_)
      @text
    end
  end

  # Progressive messages depend on the number of attemps
  # They work with exactly two or three messages:
  #
  #  * the first message will be displayed in the first three attemps
  #  * the second message will be displayed in the fourth, fifth and sixth attemps
  #  * the third message will be displayed starting at the seventh attemp
  #
  class Progressive
    def initialize(alternatives)
      raise 'You need two or three alternatives' unless alternatives.size.between?(2, 3)
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
    elsif text_or_alternatives.is_a? Array
      Progressive.new text_or_alternatives
    else
      raise "Wrong message format #{text_or_alternatives}"
    end
  end
end
