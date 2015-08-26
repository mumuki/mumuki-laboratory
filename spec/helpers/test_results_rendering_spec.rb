require 'spec_helper'
require 'ostruct'

describe WithTestResultsRendering do
  helper WithIcons
  helper WithTestResultsRendering

  let(:html) { render_test_results solution }

  context 'structured results' do
    context 'when single passed submission' do
      let(:solution) { OpenStruct.new(
        test_results: [{title: '2 is 2', status: :passed, result: ''}],
        output_content_type: ContentType::Plain) }

      it { expect(html).to be_html_safe }
      it { expect(html).to include "<i class=\"fa fa-check text-success special-icon\"></i>" }
      it { expect(html).to include "<span class=\"example-title text-success\">2 is 2</span>" }
    end

    context 'when single failed submission' do
      context 'when plain results' do
        let(:solution) { OpenStruct.new(
          test_results: [{title: '2 is 2', status: :failed, result: 'something _went_ wrong'}],
          output_content_type: ContentType::Plain) }

        it { expect(html).to include "<i class=\"fa fa-times text-danger special-icon\"></i>" }
        it { expect(html).to include "<strong class=\"example-title\">2 is 2</strong>" }
        it { expect(html).to include "<pre>something _went_ wrong</pre>" }
      end

      context 'when markdown results' do
        let(:solution) { OpenStruct.new(
          test_results: [{title: '2 is 2', status: :failed, result: 'something went _really_ wrong'}],
          output_content_type: ContentType::Markdown) }

        it { expect(html).to include "<i class=\"fa fa-times text-danger special-icon\"></i>" }
        it { expect(html).to include "<strong class=\"example-title\">2 is 2</strong>" }
        it { expect(html).to include "<p>something went <em>really</em> wrong</p>" }
      end
    end
  end

  context 'unstructured results' do
    let(:solution) { OpenStruct.new(result_html: '<pre>ooops, something went wrong</pre>'.html_safe) }

    it { expect(html).to be_html_safe }
    it { expect(html).to eq '<pre>ooops, something went wrong</pre>' }
  end
end
