require 'spec_helper'

describe OrganizationListHelper, organization_workspace: :test do
  helper OrganizationListHelper

  context 'not not users path' do
    let(:request) { struct path: '/guides/1' }

    it { expect(organization_switch_url(Organization.current)).to eq 'http://test.localmumuki.io/guides/1' }
  end

  context 'on users path' do
    let(:request) { struct path: '/users/' }
    let(:controller_name) { 'users' }

    it { expect(organization_switch_url(Organization.current)).to eq 'http://test.localmumuki.io/' }
  end
end


