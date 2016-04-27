require 'spec_helper'

describe Organization do
  let(:organization) { Organization.find_by(name: 'test') }

  it { expect(organization).to_not be nil }
  it { expect(organization).to eq Organization.current }

end
