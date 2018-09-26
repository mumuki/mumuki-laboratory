require 'spec_helper'

describe 'not found on api', type: :request, organization_workspace: :base do
  before { set_subdomain_host! Organization.base.name }
  before { Organization.base.switch! }

  let(:owner_api_client) { create :api_client, role: :owner, grant: '*' }

  it 'without authentication' do
    get '/api/nonexistentroute'

    expect(response.body).to json_eq errors: ['not found']
    expect(response.status).to eq 404
  end

  it 'with authentication' do
    get '/api/nonexistentroute', headers: { 'Authorization': owner_api_client.token, 'Content-Type': 'application/json' }

    expect(response.body).to json_eq errors: ['not found']
    expect(response.status).to eq 404
  end
end
