require 'spec_helper'

describe Stats do

  context 'with good stats' do
    let(:stats) { Stats.new(passed: 6, passed_with_warnings: 3, failed: 1, unknown: 0) }
    it { expect(stats.done?).to be false }
  end


  context 'with bad stats' do
    let(:stats) { Stats.new(passed: 1, passed_with_warnings: 0, failed: 4, unknown: 5) }
    it { expect(stats.done?).to be false }
  end

  describe '#to_h' do
    let(:hash) { {passed: 4, passed_with_warnings: 3, failed: 2, unknown: 1} }
    let(:stats) { Stats.new(hash) }

    it { expect(stats.to_h { |it| it }).to eq(hash) }
  end
end
