module Mumukit::Assistant::Rule
  def self.parse(hash)
    message = Mumukit::Assistant::Message.parse hash[:message]
    case hash[:type]
      when :content_empty                    then Mumukit::Assistant::Rule::ContentEmpty.new(message)
      when :submission_errored               then Mumukit::Assistant::Rule::SubmissionErrored.new(message, hash[:contains])
      when :submission_failed                then Mumukit::Assistant::Rule::SubmissionFailed.new(message)
      when :submission_passed_with_warnings  then Mumukit::Assistant::Rule::SubmissionPassedWithWarnings.new(message, hash[:expectations])
      else raise "Unsupported rule #{hash[:type]}"
    end
  end

  def self.parse_many(hashes)
    hashes.map { |it| parse it }
  end

  class Base
    attr_accessor :message
    def initialize(message)
      @message = message
    end

    def message_for(retries)
      message.call(retries)
    end
  end

  class ContentEmpty < Base
    def matches?(submission)
      submission.content.empty?
    end
  end

  class SubmissionFailed < Base
    def matches?(submission)
      submission.status.failed?
    end
  end

  class SubmissionPassedWithWarnings < Base
    def initialize(message, expectations)
      super(message)
      @expectations = expectations
    end

    def matches?(submission)
      submission.status.passed_with_warnings? && matches_failing_expectations?(submission)
    end

    def matches_failing_expectations?(submission)
      (@expectations || []).all? do |it|
        includes_failing_expectation? it, submission.expectation_results
      end
    end

    def includes_failing_expectation?(humanized_expectation, expectation_results)
      binding, inspection = humanized_expectation.split(' ')
      expectation_results.include? binding: binding, inspection: inspection, result: :failed
    end
  end

  class SubmissionErrored < Base
    def initialize(message, text)
      super(message)
      @text = text
    end

    def matches?(submission)
      submission.status.errored? && includes_text?(submission)
    end

    def includes_text?(submission)
      @text.blank? || submission.result.include?(@text)
    end
  end
end