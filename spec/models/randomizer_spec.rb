require 'spec_helper'

describe Mumukit::Randomizer do
  let(:randomizer) { Mumukit::Randomizer.parse(randomizations) }

  describe '#with_seed' do
    before { Mumukit::Randomizer::Randomization::Base.any_instance.stub(:modulo) { |_, value, range| value % range.size + range.first } }
    let(:randomizer) { Mumukit::Randomizer.parse(some_string: { type: :oneOf, value: %w(some string) }, some_number: { type: :range, value: [1, 3] } ) }

    it { expect(randomizer.with_seed 0).to eq(some_string: 'some', some_number: 1) }
    it { expect(randomizer.with_seed 1).to eq(some_string: 'string', some_number: 1) }
    it { expect(randomizer.with_seed 2).to eq(some_string: 'some', some_number: 2) }
    it { expect(randomizer.with_seed 3).to eq(some_string: 'string', some_number: 2) }
    it { expect(randomizer.with_seed 4).to eq(some_string: 'some', some_number: 3) }
    it { expect(randomizer.with_seed 5).to eq(some_string: 'string', some_number: 3) }
    it { expect(randomizer.with_seed 6).to eq(some_string: 'some', some_number: 1) }
  end
end
