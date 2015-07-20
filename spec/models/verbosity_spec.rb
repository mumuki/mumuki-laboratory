require 'spec_helper'

describe Verbosity do
  let(:results) { [{result: :passed, inspection: 'HasBinding', binding: 'foo'},
                   {result: :failed, inspection: 'HasBinding', binding: 'bar'}] }

  describe Verbosity::Verbose do
    it { expect(Verbosity::Verbose.visible_expectation_results(results)).to eq (results) }
  end

  describe Verbosity::Standard do
    it { expect(Verbosity::Standard.visible_expectation_results(results)).to eq ([
        {result: :failed, inspection: 'HasBinding', binding: 'bar'}]) }
  end

  describe Verbosity::Silent do
    it { expect(Verbosity::Silent.visible_expectation_results(results)).to be_empty }
  end

end
