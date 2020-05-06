require 'spec_helper'
require 'ostruct'

describe ContextualizationResultHelper do
  helper IconsHelper
  helper FontAwesome::Rails::IconHelper
  helper ContextualizationResultHelper


  describe 'humanized_expectation_result_item' do
    let(:html) { humanized_expectation_result_item expectation_result }

    context 'plain explanation' do
      let(:expectation_result) { {result: :failed, explanation: 'you must delegate'} }

      it { expect(html).to eq '<li><i class="fa fa-times-circle text-danger status-icon"></i> you must delegate</li>' }

    end

    context 'html explanation' do
      let(:expectation_result) { {result: :failed, explanation: 'you must use <strong>if</strong>'} }

      it { expect(html).to eq '<li><i class="fa fa-times-circle text-danger status-icon"></i> you must use <strong>if</strong></li>' }
    end

    context 'markdown explanation' do
      let(:expectation_result) { {result: :failed, explanation: 'you must call `fooBar`'} }

      it { expect(html).to eq '<li><i class="fa fa-times-circle text-danger status-icon"></i> you must call <code>fooBar</code></li>' }
    end
  end

  describe 'render_test_results' do
    let(:html) { render_test_results contextualization }

    context 'structured results' do
      context 'when single passed submission' do
        let(:contextualization) { struct(
          exercise: struct(hidden?: false),
          test_results: [{title: '2 is 2', status: :passed, result: ''}],
          output_content_type: Mumukit::ContentType::Plain) }

        it { expect(html).to be_html_safe }
        it { expect(html).to include "<i class=\"fa fa-check-circle text-success status-icon\"></i>" }
        it { expect(html).to include "2 is 2" }
      end

      context 'when single failed submission' do
        context 'when plain results' do
          let(:contextualization) { struct(
            exercise: struct(hidden?: false),
            test_results: [{title: '2 is 2', status: :failed, result: 'something _went_ wrong'}],
            output_content_type: Mumukit::ContentType::Plain) }

          it { expect(html).to include "<i class=\"fa fa-times-circle text-danger status-icon\"></i>" }
          it { expect(html).to include "<strong class=\"example-title\">2 is 2</strong>" }
          it { expect(html).to include "<pre>something _went_ wrong</pre>" }
        end

        context 'when markdown results' do
          let(:contextualization) { struct(
            exercise: struct(hidden?: false),
            test_results: [{title: '2 is 2', status: :failed, result: 'something went _really_ wrong'}],
            output_content_type: Mumukit::ContentType::Markdown) }

          it { expect(html).to include "<i class=\"fa fa-times-circle text-danger status-icon\"></i>" }
          it { expect(html).to include "<strong class=\"example-title\">2 is 2</strong>" }
          it { expect(html).to include "<p>something went <em>really</em> wrong</p>" }
        end

        context 'when markdown results with summary' do
          let(:contextualization) { struct(
            exercise: struct(hidden?: false),
            test_results: [{title: 'foo is 2', status: :failed, result: 'foo is undefined', summary: {type: 'undefined_variable', summary: 'you are using things that are **not defined**'}}],
            output_content_type: Mumukit::ContentType::Markdown) }

          it { expect(html).to eq "" }
        end
      end
    end

    context 'unstructured results' do
      let(:contextualization) { struct(
        exercise: struct(hidden?: false),
        result_html: '<pre>ooops, something went wrong</pre>'.html_safe) }

      it { expect(html).to be_html_safe }
      it { expect(html).to include '<pre>ooops, something went wrong</pre>' }
      it { expect(html).to include '<strong>Results:</strong>' }
    end
  end
end
