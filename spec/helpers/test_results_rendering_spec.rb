require 'spec_helper'
require 'ostruct'

describe ContextualizationResultHelper do
  helper IconsHelper
  helper FontAwesome::Rails::IconHelper
  helper ContextualizationResultHelper


  describe 'render_affable_expectation_result' do
    let(:html) { render_affable_expectation_result expectation_result }

    context 'plain explanation' do
      let(:expectation_result) { {result: :failed, explanation: 'you must delegate'} }

      it { expect(html).to eq '<i class="fa fa-times-circle text-danger status-icon"></i> you must delegate' }
    end

    context 'html explanation' do
      let(:expectation_result) { {result: :failed, explanation: 'you must use <strong>if</strong>'} }

      it { expect(html).to eq '<i class="fa fa-times-circle text-danger status-icon"></i> you must use <strong>if</strong>' }
    end
  end

  describe 'render_test_results' do
    let(:html) { render_test_results contextualization }

    context 'structured results' do
      context 'when single passed submission' do
        let(:language) { build(:language, output_content_type: :plain) }
        let(:problem) { build(:problem, language: language) }
        let(:contextualization) { Assignment.new(
          exercise: problem,
          test_results: [{title: '2 is 2', status: :passed, result: ''}]) }

        it { expect(html).to be_html_safe }
        it { expect(html).to include "<i class=\"fa fa-check-circle text-success status-icon\"></i>" }
        it { expect(html).to include "2 is 2" }
      end

      context 'when single failed submission' do
        context 'when plain results' do
          let(:language) { build(:language, output_content_type: :plain) }
          let(:problem) { build(:problem, language: language) }
          let(:contextualization) { Assignment.new(
            exercise: problem,
            test_results: [{title: '2 is 2', status: :failed, result: 'something _went_ wrong'}]) }

          it { expect(html).to include "<i class=\"fa fa-times-circle text-danger status-icon\"></i>" }
          it { expect(html).to include "2 is 2" }
          it { expect(html).to include "<pre>something _went_ wrong</pre>" }
        end

        context 'when markdown results' do
          let(:language) { build(:language, output_content_type: :markdown) }
          let(:problem) { build(:problem, language: language) }
          let(:contextualization) { Assignment.new(
            exercise: problem,
            test_results: [{title: '2 is 2', status: :failed, result: 'something went _really_ wrong'}]) }

          it { expect(html).to include "<i class=\"fa fa-times-circle text-danger status-icon\"></i>" }
          it { expect(html).to include "2 is 2" }
          it { expect(html).to include "<p>something went <em>really</em> wrong</p>" }
        end

        context 'when markdown results with summary and title' do
          let(:language) { build(:language, output_content_type: :markdown) }
          let(:problem) { build(:problem, language: language) }
          let(:contextualization) { Assignment.new(
            exercise: problem,
            test_results: [{title: 'foo is 2', status: :failed, result: 'foo is undefined', summary: {type: 'undefined_variable', message: 'you are using things that are _not defined_'}}]) }

          it { expect(html).to include 'foo is 2: you are using things that are <em>not defined</em>' }
          it { expect(html).to include "<i class=\"fa fa-times-circle text-danger status-icon\"></i>" }
          it { expect(html).to include '<p>foo is undefined</p>' }
        end

        context 'when markdown results with summary and no title' do
          let(:language) { build(:language, output_content_type: :markdown) }
          let(:problem) { build(:problem, language: language) }
          let(:contextualization) { Assignment.new(
            exercise: problem,
            test_results: [{title: '', status: :failed, result: 'foo is undefined', summary: {type: 'undefined_variable', message: 'you are using things that are _not defined_'}}]) }

          it { expect(html).to include 'you are using things that are <em>not defined</em>' }
          it { expect(html).to include "<i class=\"fa fa-times-circle text-danger status-icon\"></i>" }
          it { expect(html).to include '<p>foo is undefined</p>' }
        end
      end
    end

    context 'unstructured results' do
      let(:language) { build(:language, )}
      let(:problem) { build(:problem, language: language) }
      let(:contextualization) { Assignment.new(
        exercise: problem,
        result: 'ooops, something went wrong'.html_safe) }

      it { expect(html).to be_html_safe }
      it { expect(html).to include '<pre>ooops, something went wrong</pre>' }
      it { expect(html).to include '<strong>Results:</strong>' }
    end
  end
end
