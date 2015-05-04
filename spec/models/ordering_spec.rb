require 'spec_helper'

describe Ordering do
  let(:attributes) { {position: 1, locale: :es} }

  it { expect(Ordering.from(nil)).to be NaturalOrdering }
  it { expect(Ordering.from([2, 3, 4])).to be_a FixedOrdering }

  it { expect(NaturalOrdering.with_position(4, attributes)).to eq attributes }

  describe FixedOrdering do
    let(:ordering) { FixedOrdering.new([4, 20, 3]) }

    it { expect(ordering.position_for(20)).to eq 2 }

    it { expect(ordering.with_position(4, attributes)).to eq(position: 1, locale: :es) }
    it { expect(ordering.with_position(20, attributes)).to eq(position: 2, locale: :es) }
    it { expect(ordering.with_position(3, attributes)).to eq(position: 3, locale: :es) }
  end
end
