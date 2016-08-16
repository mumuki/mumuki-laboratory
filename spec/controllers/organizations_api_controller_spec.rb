require 'spec_helper'

describe Api::OrganizationsController do
  describe 'get' do
    before { get :index, {name: 'test'} }

    it { expect(response.status).to eq 200 }
    it { expect(JSON.parse(response.body)['organization']['name']).to eq 'test' }
    it { expect(JSON.parse(response.body)['organization']['lock_json']['connections']).to eq ['Username-Password-Authentication'] }
  end
end
