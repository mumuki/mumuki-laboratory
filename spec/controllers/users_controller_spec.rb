require 'spec_helper'

describe UsersController, type: :controller, organization_workspace: :test do
  let(:user) { create(:user) }

  let(:user_json) do
    {
      first_name: 'foo',
      last_name: 'bar',
      email: 'foo@bar.com'
    }
  end

  context 'put' do
    before { set_current_user! user }
    before { put :update, body: { user: user_json }.to_json, as: :json }

    it { expect(User.last.first_name).to eq 'foo' }
    it { expect(User.last.verified_first_name).to be_nil }
  end
end
