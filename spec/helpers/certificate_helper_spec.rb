require 'spec_helper'

describe CertificateHelper, organization_workspace: :test do
  helper CertificateHelper

  describe '#linkedin_url_to_post' do
    let(:certificate) { create :certificate, code: 'abc', created_at: Time.new(2000, 1, 1) }
    let(:link) { "https://www.linkedin.com/profile/add?startTask=CERTIFICATION_NAME&name=Test&organizationId=3648837&issueYear=2000&issueMonth=1&certUrl=http%3A%2F%2Ftest.localmumuki.io%2Fcertificates%2Fverify%2Fabc&certId=abc" }

    it { expect(linkedin_url_to_post(certificate).to_s).to eq link }
  end

end
