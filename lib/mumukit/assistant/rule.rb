module Mumukit::Assistant::Rule
  def self.parse(hash)
    message = Mumukit::Assistant::Message.parse hash[:then]
    w = hash[:when]
    if w.is_a? Hash
      parse_complex_when w.first, message
    else
      parse_simple_when w, message
    end
  end

  def self.parse_simple_when(w, message)
    case w
      when :content_empty                    then Mumukit::Assistant::Rule::ContentEmpty.new(message)
      when :submission_errored               then Mumukit::Assistant::Rule::SubmissionErrored.new(message)
      when :submission_failed                then Mumukit::Assistant::Rule::SubmissionFailed.new(message)
      when :submission_passed_with_warnings  then Mumukit::Assistant::Rule::SubmissionPassedWithWarnings.new(message)
      else raise "Unsupported rule #{w}"
    end
  end

  def self.parse_complex_when(w, message)
    condition, value = *w
    case condition
      when :error_contains            then Mumukit::Assistant::Rule::ErrorContains.new(message, value)
      when :these_tests_failed        then Mumukit::Assistant::Rule::TheseTestsFailed.new(message, value)
      when :only_these_tests_failed   then Mumukit::Assistant::Rule::OnlyTheseTestsFailed.new(message, value)
      when :these_expectations_failed then Mumukit::Assistant::Rule::TheseExpectationsFailed.new(message, value)
      else raise "Unsupported rule #{condition}"
    end
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

  class TheseTestsFailed < SubmissionFailed
    def initialize(message, tests)
      raise 'missing tests' if tests.blank?
      super(message)
      @tests = tests
    end

    def matches?(submission)
      super && matches_failing_tests?(submission)
    end

    def matches_failing_tests?(submission)
      @tests.all? do |it|
        includes_failing_test? it, submission
      end
    end

    def includes_failing_test?(title, submission)
      failed_tests(submission).map { |it| it[:title] }.include?(title)
    end

    def failed_tests(submission)
      submission.test_results.select { |it| it[:status].failed? }
    end
  end

  class OnlyTheseTestsFailed < TheseTestsFailed
    def matches_failing_tests?(submission)
      super && failed_tests(submission).count == @tests.count
    end
  end

  class SubmissionPassedWithWarnings < Base
    def matches?(submission)
      submission.status.passed_with_warnings?
    end
  end

  class TheseExpectationsFailed < SubmissionPassedWithWarnings
    def initialize(message, expectations)
      raise 'missing expectations' if expectations.blank?
      super(message)
      @expectations = expectations
    end

    def matches?(submission)
      super && matches_failing_expectations?(submission)
    end

    def matches_failing_expectations?(submission)
      @expectations.all? do |it|
        includes_failing_expectation? it, submission.expectation_results
      end
    end

    def includes_failing_expectation?(humanized_expectation, expectation_results)
      binding, inspection = humanized_expectation.split(' ')
      expectation_results.include? binding: binding, inspection: inspection, result: :failed
    end
  end

  class SubmissionErrored < Base
    def matches?(submission)
      submission.status.errored?
    end
  end

  class ErrorContains < SubmissionErrored
    def initialize(message, text)
      super(message)
      @text = text
    end

    def matches?(submission)
      super && submission.result.include?(@text)
    end
  end
end