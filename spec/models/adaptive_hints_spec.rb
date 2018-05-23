require 'spec_helper'

module Mumukit
  class Assistant
    def initialize(rules)
      @rules = rules.map { |it| Mumukit::Assistant::Rule.parse it }
    end

    def assist_with(submission)
      @rules.map { |it| it.call(submission)&.call(submission.retries) }.compact
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
          when :submission_errored               then Mumukit::Assistant::Rule::SubmissionStatus.new(message, &:errored?)
          when :submission_failed                then Mumukit::Assistant::Rule::SubmissionStatus.new(message, &:failed?)
          when :submission_passed_with_warnings  then Mumukit::Assistant::Rule::SubmissionStatus.new(message, &:passed_with_warnings?)
          else raise "Unsupported rule #{hash[:type]}"
        end
      end

      class Base
        attr_accessor :message
        def initialize(message)
          @message = message
        end
      end

      class ContentEmpty < Base
        def call(submission)
          message if submission.content.empty?
        end
      end

      class SubmissionStatus < Base
        def initialize(message, &block)
          super(message)
          @block = block
        end
        def call(submission)
          message if @block.call(submission.status)
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

end

