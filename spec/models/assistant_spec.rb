require 'spec_helper'

describe Mumukit::Assistant do
  let(:assistant) { Mumukit::Assistant.parse(rules) }

  describe 'content_empty' do
    let(:rules) {[
      {when: :content_empty, then: 'oops, please write something in the editor'}
    ]}

    context 'when submission has content' do
      let(:submission) { struct content: 'something' }
      it { expect(assistant.assist_with submission).to eq [] }
    end

    context 'when submission has no content' do
      let(:submission) { struct content: '' }
      it { expect(assistant.assist_with submission).to eq ['oops, please write something in the editor'] }
    end
  end

  describe 'content_empty with attemps_count' do
    let(:rules) {[
      {
        when: :content_empty,
        then: ['message 1', 'message 2', 'message 3']
      }
    ]}

    context 'when submission has content' do
      let(:submission) { struct content: 'something' }
      it { expect(assistant.assist_with submission).to eq [] }
    end

    context 'when submission has no content' do
      it { expect(assistant.assist_with(struct content: '', attemps_count: 1)).to eq ['message 1'] }
      it { expect(assistant.assist_with(struct content: '', attemps_count: 3)).to eq ['message 1'] }
      it { expect(assistant.assist_with(struct content: '', attemps_count: 4)).to eq ['message 2'] }
      it { expect(assistant.assist_with(struct content: '', attemps_count: 6)).to eq ['message 2'] }
      it { expect(assistant.assist_with(struct content: '', attemps_count: 7)).to eq ['message 3'] }
      it { expect(assistant.assist_with(struct content: '', attemps_count: 10)).to eq ['message 3'] }
    end
  end

  describe 'submission_errored' do
    let(:rules) {[
      {when: :submission_errored, then: 'oops, it did not compile'}
    ]}

    context 'when submission has errored' do
      let(:submission) { struct status: :errored }
      it { expect(assistant.assist_with submission).to eq ['oops, it did not compile'] }
    end

    context 'when submission has not errored' do
      let(:submission) { struct status: :passed }
      it { expect(assistant.assist_with submission).to eq [] }
    end
  end

  describe 'error_contains with contains' do
    let(:rules) {[
      {
        when: :submission_errored,
        then: 'Oops, it did not compile'
      },
      {
        when: { error_contains: 'Unrecognized token %' },
        then: 'Remember you have to use `mod`, not `%`'
      }
    ]}

    context 'when submission has errored with expected message' do
      let(:submission) { struct status: :errored, result: 'Illegal start of sentence. Unrecognized token %'  }
      it do
        expect(assistant.assist_with submission).to eq ['Oops, it did not compile', 'Remember you have to use `mod`, not `%`']
      end
    end

    context 'when submission has errored without expected message' do
      let(:submission) { struct status: :errored, result: 'Illegal start of sentence'  }
      it { expect(assistant.assist_with submission).to eq ['Oops, it did not compile'] }
    end


    context 'when submission has not errored' do
      let(:submission) { struct status: :passed }
      it { expect(assistant.assist_with submission).to eq [] }
    end
  end

  describe 'submission_failed' do
    let(:rules) {[
      {when: :submission_failed, then: 'oops, it did not pass'}
    ]}

    context 'when submission has failed' do
      let(:submission) { struct status: :failed }
      it { expect(assistant.assist_with submission).to eq ['oops, it did not pass'] }
    end

    context 'when submission has not failed' do
      let(:submission) { struct status: :passed }
      it { expect(assistant.assist_with submission).to eq [] }
    end
  end

  describe 'these_tests_failed' do
    let(:rules) {[
      {
        when: {
          these_tests_failed: [
            'f -2 should return 1',
            'f -5 should return 1']
        },
        then: 'oops, failed!'}
    ]}

    context 'when given tests have failed' do
      let(:submission) {
        struct status: :failed,
               test_results: [
                  {title: 'f -2 should return 1', status: :failed, result: '.'},
                  {title: 'f -5 should return 1', status: :failed, result: '.'},
                  {title: 'f -6 should return 1', status: :failed, result: '.'},
               ]
      }
      it { expect(assistant.assist_with submission).to eq ['oops, failed!'] }
    end

    context 'when given tests have not failed' do
      let(:submission) {
        struct status: :failed,
               test_results: [
                  {title: 'f -2 should return 1', status: :failed, result: '.'},
                  {title: 'f -5 should return 1', status: :passed, result: '.'},
                  {title: 'f -6 should return 1', status: :failed, result: '.'},
               ]
      }
      it { expect(assistant.assist_with submission).to eq [] }
    end
  end

  describe 'only_these_tests_failed' do
    let(:rules) {[
      {
        when: {
          only_these_tests_failed: [
            'f -2 should return 1',
            'f -5 should return 1']
        },
        then: 'oops, failed!'}
    ]}

    context 'when given tests have failed, and no others' do
      let(:submission) {
        struct status: :failed,
               test_results: [
                  {title: 'f -2 should return 1', status: :failed, result: '.'},
                  {title: 'f -5 should return 1', status: :failed, result: '.'},
                  {title: 'f -6 should return 1', status: :passed, result: '.'},
               ]
      }
      it { expect(assistant.assist_with submission).to eq ['oops, failed!'] }
    end

    context 'when given tests have failed, but others too' do
      let(:submission) {
        struct status: :failed,
               test_results: [
                  {title: 'f -2 should return 1', status: :failed, result: '.'},
                  {title: 'f -5 should return 1', status: :failed, result: '.'},
                  {title: 'f -6 should return 1', status: :failed, result: '.'},
               ]
      }
      it { expect(assistant.assist_with submission).to eq [] }
    end

    context 'when given tests have not failed' do
      let(:submission) {
        struct status: :failed,
               test_results: [
                  {title: 'f -2 should return 1', status: :failed, result: '.'},
                  {title: 'f -5 should return 1', status: :passed, result: '.'},
                  {title: 'f -6 should return 1', status: :failed, result: '.'},
               ]
      }
      it { expect(assistant.assist_with submission).to eq [] }
    end
  end

  describe 'submission_passed_with_warnings' do
    let(:rules) {[
      {when: :submission_passed_with_warnings, then: 'oops, it did not pass'}
    ]}

    context 'when submission has passed_with_warnings' do
      let(:submission) { struct status: :passed_with_warnings }
      it { expect(assistant.assist_with submission).to eq ['oops, it did not pass'] }
    end

    context 'when submission has not passed_with_warnings' do
      let(:submission) { struct status: :passed }
      it { expect(assistant.assist_with submission).to eq [] }
    end
  end

  describe 'submission_passed_with_warnings with expectations' do
    let(:rules) {[{
      when: {
        these_expectations_failed: [
          'Foo DeclaresMethod:getBar',
          'Foo DeclaresAttribute:bar'
        ]
      },
      then: 'You must declare getter bar'
    }]}

    context 'when submission has passed_with_warnings with matching expectations' do
      let(:submission) {
        struct status: :passed_with_warnings,
               expectation_results: [
                 {binding: "Foo", inspection: "DeclaresMethod:getBar", result: :failed},
                 {binding: "Foo", inspection: "DeclaresAttribute:bar",  result: :failed},
                 {binding: "foo", inspection: "DeclaresAttribute:baz", result: :failed}] }

      it { expect(assistant.assist_with submission).to eq ['You must declare getter bar'] }
    end

    context 'when submission has passed_with_warnings without matching all expectations' do
      let(:submission) {
        struct status: :passed_with_warnings,
               expectation_results: [
                {binding: "Foo", inspection: "DeclaresMethod:getBar", result: :failed},
                {binding: "Foo", inspection: "DeclaresAttribute:bar",  result: :passed},
                {binding: "foo", inspection: "DeclaresAttribute:baz", result: :failed}] }

      it { expect(assistant.assist_with submission).to eq [] }
    end
  end

end

