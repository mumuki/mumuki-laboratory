require 'spec_helper'

describe Apartment::Tenant do
  describe '#on?' do
    it { expect(Apartment::Tenant.on? 'test').to be true }
    it { expect(Apartment::Tenant.on? 'foo').to be false }
  end
end