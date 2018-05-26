require 'spec_helper'

describe 'adaptive hints' do
  let(:assistant) { Mumukit::Assistant.new(rules.map { |it| Mumukit::Assistant::Rule.parse it }) }

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

