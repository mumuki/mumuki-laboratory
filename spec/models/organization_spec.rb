require 'spec_helper'

describe Organization do
  let(:organization) { Organization.find_by(name: 'test') }
  let(:user) { create(:user) }

  it { expect(organization).to_not be nil }
  it { expect(organization).to eq Organization.current }

  describe '#notify_recent_assignments!' do
    it { expect { organization.notify_recent_assignments! 1.minute.ago }.to_not raise_error }
  end

  describe '#notify_assignments_by!' do
    it { expect { organization.notify_assignments_by! user }.to_not raise_error }
  end

end
