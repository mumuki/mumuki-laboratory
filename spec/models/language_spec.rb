require 'spec_helper'

describe Language do
  let!(:gobstones) { create(:language, name: 'Gobstones') }

  it { expect { create :language, name: 'gobstones' }.to raise_exception }
  it { expect(Language.for_name 'gobstones').to eq gobstones }
  it { expect(Language.for_name nil).to be nil}
  it { expect(gobstones.prompt).to eq 'ム '}

end
