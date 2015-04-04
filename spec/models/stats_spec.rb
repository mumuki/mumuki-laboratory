require 'spec_helper'

describe Stats do

  context 'with good stats' do
    let(:stats) { Stats.new(passed: 9, failed: 1, unknown: 0) }
    it { expect(stats.passed_ratio).to eq 90 }
    it { expect(stats.failed_ratio).to eq 10 }
    it { expect(stats.good_progress?).to be true }
    it { expect(stats.stuck?).to be false }
    it { expect(stats.done?).to be false }
  end


  context 'with bad stats' do
    let(:stats) { Stats.new(passed: 1, failed: 4, unknown: 5) }
    it { expect(stats.passed_ratio).to eq 10 }
    it { expect(stats.failed_ratio).to eq 40 }
    it { expect(stats.good_progress?).to be false }
    it { expect(stats.stuck?).to be true }
    it { expect(stats.done?).to be false }
  end
end
