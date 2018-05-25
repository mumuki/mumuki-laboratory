module Mumukit
  class Assistant
    def initialize(rules)
      @rules = rules.map { |it| Mumukit::Assistant::Rule.parse it }
    end

    def assist_with(submission)
      @rules
        .select { |it| it.matches?(submission) }
        .map { |it| it.message_for(submission.retries) }
    end
  end
end

require_relative './assistant/rule'
require_relative './assistant/message'