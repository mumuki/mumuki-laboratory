require 'spec_helper'
require 'ostruct'

describe TestResultsRendering do
  helper Icons
  helper TestResultsRendering

  let(:html) { render_test_results submission }

  context 'structured results' do
    context 'when single passed submission' do
      let(:submission) { OpenStruct.new(test_results: [{title: '2 is 2', status: :passed, result: ''}]) }
      it { expect(html).to be_html_safe }
      it { expect(html).to include "<i class=\"fa fa-check text-success special-icon\"></i>" }
      it { expect(html).to include "<span class=\"example-title\">2 is 2</span>" }
    end

    context 'when single failed submission' do
      context 'when plain results' do
        let(:submission) { OpenStruct.new(test_results: [{title: '2 is 2', status: :failed, result: 'something _went_ wrong'}]) }
        it { expect(html).to include "<i class=\"fa fa-times text-danger special-icon\"></i>" }
        it { expect(html).to include "<strong class=\"example-title\">2 is 2</strong>" }
        it { expect(html).to include "<pre><code>something _went_ wrong</code></pre>" }
      end

      context 'when markdown results' do
        let(:submission) { OpenStruct.new(test_results: [{title: '2 is 2', status: :failed, result: 'something went _really_ wrong'}]) }
        it { expect(html).to include "<i class=\"fa fa-times text-danger special-icon\"></i>" }
        it { expect(html).to include "<strong class=\"example-title\">2 is 2</strong>" }
        it { expect(html).to include "<pre><code>something <em>really</em> wrong</code></pre>" }
      end
    end
  end

  context 'unstructured results' do
    let(:submission) { OpenStruct.new(result_html: '<pre>ooops, something went wrong</pre>'.html_safe) }

    it { expect(html).to be_html_safe }
    it { expect(html).to eq '<pre>ooops, something went wrong</pre>' }
  end
end
