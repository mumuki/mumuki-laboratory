require 'spec_helper'
require 'ostruct'

module TestResultsRendering
  def render_test_results(submission)
    render partial: 'layouts/test_results', locals: {test_results: submission.test_results}
  end
end

describe TestResultsRendering do
  helper Icons
  helper TestResultsRendering

  let(:html) { render_test_results submission }
  let(:html_s) { html.strip }

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
