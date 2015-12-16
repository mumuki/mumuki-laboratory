require 'spec_helper'

describe Tenant do
  describe '#on?' do
    it { expect(Tenant.on? 'test').to be true }
    it { expect(Tenant.on? 'foo').to be false }
  end
end