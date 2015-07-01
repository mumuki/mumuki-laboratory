require 'spec_helper'

describe Language do
  let!(:gobstones) { create(:language, name: 'Gobstones') }

  it { expect { create :language, name: 'Gobstones' }.to raise_exception }
end
