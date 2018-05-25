require 'spec_helper'

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

    class Message
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

    module Rule
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
  end
end

describe 'adaptive hints' do
  let(:assistant) { Mumukit::Assistant.new(rules) }

  describe 'content_empty rule' do
    let(:rules) {[
      {type: :content_empty, message: 'oops, please write something in the editor'}
    ]}

    context 'when submission has content' do
      let(:submission) { struct content: 'something' }
      it do
        expect(assistant.assist_with submission).to eq []
      end
    end

    context 'when submission has no content' do
      let(:submission) { struct content: '' }
      it do
        expect(assistant.assist_with submission).to eq ['oops, please write something in the editor']
      end
    end
  end

  describe 'content_empty with retries rule' do
    let(:rules) {[
      {
        type: :content_empty,
        message: ['message 1', 'message 2', 'message 3']
      }
    ]}

    context 'when submission has content' do
      let(:submission) { struct content: 'something' }
      it do
        expect(assistant.assist_with submission).to eq []
      end
    end

    context 'when submission has no content, for the first time' do
      let(:submission) { struct content: '', retries: 1 }
      it do
        expect(assistant.assist_with submission).to eq ['message 1']
      end
    end

    context 'when submission has no content, for the second time' do
      let(:submission) { struct content: '', retries: 2 }
      it do
        expect(assistant.assist_with submission).to eq ['message 2']
      end
    end

    context 'when submission has no content, for the third time' do
      let(:submission) { struct content: '', retries: 3 }
      it do
        expect(assistant.assist_with submission).to eq ['message 3']
      end
    end

    context 'when submission has no content, for the fourth time' do
      let(:submission) { struct content: '', retries: 4 }
      it do
        expect(assistant.assist_with submission).to eq ['message 3']
      end
    end
  end

  describe 'submission_errored rule' do
    let(:rules) {[
      {type: :submission_errored, message: 'oops, it did not compile'}
    ]}

    context 'when submission has errored' do
      let(:submission) { struct status: :errored }
      it do
        expect(assistant.assist_with submission).to eq ['oops, it did not compile']
      end
    end

    context 'when submission has not errored' do
      let(:submission) { struct status: :passed }
      it do
        expect(assistant.assist_with submission).to eq []
      end
    end
  end

  describe 'submission_errored with contains rule' do
    let(:rules) {[
      {
        type: :submission_errored,
        message: 'Oops, it did not compile'
      },
      {
        type: :submission_errored,
        contains: 'Unrecognized token %',
        message: 'Remeber you have to use `mod`, not `%`'
      }
    ]}

    context 'when submission has errored with expected message' do
      let(:submission) { struct status: :errored, result: 'Illegal start of sentence. Unrecognized token %'  }
      it do
        expect(assistant.assist_with submission).to eq ['Oops, it did not compile', 'Remeber you have to use `mod`, not `%`']
      end
    end

    context 'when submission has errored without expected message' do
      let(:submission) { struct status: :errored, result: 'Illegal start of sentence'  }
      it do
        expect(assistant.assist_with submission).to eq ['Oops, it did not compile']
      end
    end


    context 'when submission has not errored' do
      let(:submission) { struct status: :passed }
      it do
        expect(assistant.assist_with submission).to eq []
      end
    end
  end

  describe 'submission_failed rule' do
    let(:rules) {[
      {type: :submission_failed, message: 'oops, it did not pass'}
    ]}

    context 'when submission has failed' do
      let(:submission) { struct status: :failed }
      it do
        expect(assistant.assist_with submission).to eq ['oops, it did not pass']
      end
    end

    context 'when submission has not failed' do
      let(:submission) { struct status: :passed }
      it do
        expect(assistant.assist_with submission).to eq []
      end
    end
  end

  describe 'submission_passed_with_warnings rule' do
    let(:rules) {[
      {type: :submission_passed_with_warnings, message: 'oops, it did not pass'}
    ]}

    context 'when submission has passed_with_warnings' do
      let(:submission) { struct status: :passed_with_warnings }
      it do
        expect(assistant.assist_with submission).to eq ['oops, it did not pass']
      end
    end

    context 'when submission has not passed_with_warnings' do
      let(:submission) { struct status: :passed }
      it do
        expect(assistant.assist_with submission).to eq []
      end
    end
  end

  describe 'submission_passed_with_warnings with expectations rule' do
    let(:rules) {[{
      type: :submission_passed_with_warnings,
      expectations: [
        'Foo DeclaresMethod:getBar',
        'Foo DeclaresAttribute:bar'
      ],
      message: 'You must declare getter bar'
    }]}

    context 'when submission has passed_with_warnings with matching expectations' do
      let(:submission) {
        struct status: :passed_with_warnings,
               expectation_results: [
                 {binding: "Foo", inspection: "DeclaresMethod:getBar", result: :failed},
                 {binding: "Foo", inspection: "DeclaresAttribute:bar",  result: :failed},
                 {binding: "foo", inspection: "DeclaresAttribute:baz", result: :failed}] }

      it do
        expect(assistant.assist_with submission).to eq ['You must declare getter bar']
      end
    end

    context 'when submission has passed_with_warnings without matching all expectations' do
      let(:submission) {
        struct status: :passed_with_warnings,
               expectation_results: [
                {binding: "Foo", inspection: "DeclaresMethod:getBar", result: :failed},
                {binding: "Foo", inspection: "DeclaresAttribute:bar",  result: :passed},
                {binding: "foo", inspection: "DeclaresAttribute:baz", result: :failed}] }

      it do
        expect(assistant.assist_with submission).to eq []
      end
    end
  end

end

