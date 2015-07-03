require 'spec_helper'
require 'ostruct'

module TestResultsRendering
  def render_test_results(submission)
    if submission.test_results.present?
      render partial: 'layouts/test_results', locals: {test_results: submission.test_results}
    else
      submission.result_html
    end
  end
end

describe TestResultsRendering do
  helper Icons
  helper TestResultsRendering

  let(:html) { render_test_results submission }
  let(:html_s) { html.strip }

  context 'structured results' do
    context 'when single passed submission' do
      let(:submission) { OpenStruct.new(test_results: [{title: '2 is 2', status: :passed, result: ''}]) }
      it { expect(html).to be_html_safe }
      it { expect(html_s).to eq "<i class=\"fa fa-check text-success special-icon\"></i>\n  <span class=\"test-result-title\">2 is 2</span>" }
    end

    context 'when single failed submission' do
      let(:submission) { OpenStruct.new(test_results: [{title: '2 is 2', status: :failed, result: ''}]) }
      it { expect(html_s).to eq "<i class=\"fa fa-times text-danger special-icon\"></i>\n  <strong class=\"test-result-title\">2 is 2</strong>" }
    end
  end

  context 'unstructured results' do
    let(:submission) { OpenStruct.new(result_html: '<pre>ooops, something went wrong</pre>'.html_safe) }

    it { expect(html).to be_html_safe }
    it { expect(html_s).to eq '<pre>ooops, something went wrong</pre>' }
  end
end
