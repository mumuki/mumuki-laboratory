require 'spec_helper'

describe Stats do

  context 'with good stats' do
    let(:stats) { Stats.new(passed: 6, passed_with_warnings: 3, failed: 1, unknown: 0) }
    it { expect(stats.passed_ratio).to eq 60 }
    it { expect(stats.resolved_ratio).to eq 90 }
    it { expect(stats.passed_with_warnings_ratio).to eq 30 }
    it { expect(stats.failed_ratio).to eq 10 }
    it { expect(stats.resolved).to eq 9 }
    it { expect(stats.good_progress?).to be true }
    it { expect(stats.stuck?).to be false }
    it { expect(stats.done?).to be false }
  end


  context 'with irrational stats' do
    let(:stats) { Stats.new(passed: 1, passed_with_warnings: 0, failed: 2, unknown: 0) }
    it { expect(stats.passed_ratio).to eq 33.33 }
    it { expect(stats.failed_ratio).to eq 66.67 }
  end


  context 'with bad stats' do
    let(:stats) { Stats.new(passed: 1, passed_with_warnings: 0, failed: 4, unknown: 5) }
    it { expect(stats.passed_ratio).to eq 10 }
    it { expect(stats.failed_ratio).to eq 40 }
    it { expect(stats.good_progress?).to be false }
    it { expect(stats.stuck?).to be true }
    it { expect(stats.done?).to be false }
  end

  describe '#to_h' do
    let(:hash) { {passed: 4, passed_with_warnings: 3, failed: 2, unknown: 1} }
    let(:stats) { Stats.new(hash) }

    it { expect(stats.to_h { |it| it }).to eq(hash) }
  end
end
