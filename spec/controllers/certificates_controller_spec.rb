require 'spec_helper'

describe CertificatesController, type: :controller, organization_workspace: :test do
  let(:user) { create(:user) }
  let(:certificate) { create(:certificate, user: user) }

  context 'download' do
    before { set_current_user! user }
    before { get :download, params: { code: certificate.code } }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to_not be_nil }
    it { expect(response.content_type).to eq 'application/pdf' }
  end
end
