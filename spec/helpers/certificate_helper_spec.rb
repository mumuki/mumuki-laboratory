require 'spec_helper'

describe CertificateHelper, organization_workspace: :test do
  helper CertificateHelper

  describe '#linkedin_url_to_post' do

    let(:certificate) { create :certificate, code: 'abc', created_at: Time.new(2000, 1, 1) }
    let(:link) { "https://www.linkedin.com/profile/add?startTask=CERTIFICATION_NAME&name=Test&organizationId=1&issueYear=2000&issueMonth=1&certUrl=http%3A%2F%2Ftest.localmumuki.io%2Fcertificates%2Fverify%2Fabc&certId=abc" }

    before { allow(ENV).to receive(:[]).with('MUMUKI_LINKEDIN_ORGANIZATION_ID').and_return '1' }
    it { expect(linkedin_post_url(certificate).to_s).to eq link }
  end

end
