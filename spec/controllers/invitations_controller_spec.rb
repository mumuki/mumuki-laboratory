require 'spec_helper'

describe InvitationsController, type: :controller, organization_workspace: :test do
  let(:user) { create(:user) }

  before { set_current_user! user }

  describe 'when invitation does not exist' do
    before { get :join, params: {code: 'foo123' } }

    it { expect(response.status).to eq 404 }
  end

  describe 'when invitation exists' do
    let(:organization) { Organization.current }
    let(:course) { create(:course, slug: 'test/foo-1111', name: 'Generic Course', organization: organization) }
    let!(:invitation) { create(:invitation, code: 'foo123', course: course ) }

    before { get :join, params: {code: 'foo123', user: {first_name: 'new first_name', gender: 'female'} } }
    before { user.reload }

    it { expect(response.status).to eq 302 }
    it { expect(user.first_name).to eq 'new first_name' }
    it { expect(user.gender).to eq 'female' }
  end
end
