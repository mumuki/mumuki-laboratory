require 'spec_helper'

describe Language do
  let!(:gobstones) { create(:language, name: 'Gobstones') }

  it { expect { create :language, name: 'gobstones' }.to raise_exception }
  it { expect(Language.for_name 'gobstones').to eq gobstones }
end
