module Mumukit
  class Assistant
    attr_accessor :rules

    def initialize(rules)
      @rules = rules
    end

    # Provides tips for the studen for the given submission,
    # based on the `rules`
    def assist_with(submission)
      @rules
        .select { |it| it.matches?(submission) }
        .map { |it| it.message_for(submission.retries) }
    end
  end
end

require_relative './assistant/rule'
require_relative './assistant/message'
require_relative './assistant/narrator'