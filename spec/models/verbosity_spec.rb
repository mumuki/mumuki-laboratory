require 'spec_helper'

describe StatusRenderingVerbosity do
  let(:results) { [{result: :passed, inspection: 'HasBinding', binding: 'foo'},
                   {result: :failed, inspection: 'HasBinding', binding: 'bar'}] }

  describe StatusRenderingVerbosity::Verbose do
    it { expect(StatusRenderingVerbosity::Verbose.visible_expectation_results(results)).to eq (results) }
  end

  describe StatusRenderingVerbosity::Standard do
    it { expect(StatusRenderingVerbosity::Standard.visible_expectation_results(results)).to eq ([
        {result: :failed, inspection: 'HasBinding', binding: 'bar'}]) }
  end

  describe StatusRenderingVerbosity::Silent do
    it { expect(StatusRenderingVerbosity::Silent.visible_expectation_results(results)).to be_empty }
    it { expect(StatusRenderingVerbosity::Silent.render_feedback?(Object.new)).to be false }

  end

end
