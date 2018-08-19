require 'spec_helper'

describe Stats do

  context 'with good stats' do
    let(:stats) { Stats.new(passed: 6, passed_with_warnings: 3, failed: 1, pending: 0) }
    it { expect(stats.done?).to be false }
  end


  context 'with bad stats' do
    let(:stats) { Stats.new(passed: 1, passed_with_warnings: 0, failed: 4, pending: 5) }
    it { expect(stats.done?).to be false }
  end
end
