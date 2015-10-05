require 'spec_helper'

def position_after_ordering(ordering, position, builder)
  ordering.with_position(position, builder)
  builder.position
end

describe Ordering do
  let(:builder) { ExerciseBuilder.new.tap { |it| it.position = 1 } }

  it { expect(Ordering.from(nil)).to be NaturalOrdering }
  it { expect(Ordering.from([2, 3, 4])).to be_a FixedOrdering }

  it { expect(position_after_ordering(NaturalOrdering, 4, builder)).to eq 1 }

  describe FixedOrdering do
    let(:ordering) { FixedOrdering.new([4, 20, 3]) }

    it { expect(ordering.position_for(20)).to eq 2 }

    it { expect(position_after_ordering(ordering, 4, builder)).to eq(1) }
    it { expect(position_after_ordering(ordering, 20, builder)).to eq(2) }
    it { expect(position_after_ordering(ordering, 3, builder)).to eq(3) }
  end
end
