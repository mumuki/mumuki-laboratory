require 'spec_helper'

describe Mumukit::Auth::LoginProvider do
  it { expect(Mumukit::Auth.config.login_provider).to be_a Mumukit::Auth::LoginProvider::Developer }

  describe Mumukit::Auth::LoginProvider::Developer do
    let(:provider) { Mumukit::Auth::LoginProvider::Developer.new }
    it { expect(provider.auth_link).to include '/auth/developer' }
    it { expect(provider.footer_html).to be_blank }
  end

  describe Mumukit::Auth::LoginProvider::Auth0 do
    let(:provider) { Mumukit::Auth::LoginProvider::Auth0.new }
    it { expect(provider.auth_link).to include 'onclick' }
    it { expect(provider.header_html).to be_present }
    it { expect(provider.footer_html).to be_present }
  end

  describe Mumukit::Auth::LoginProvider::Saml do
    let(:provider) { Mumukit::Auth::LoginProvider::Saml.new }
    it { expect(provider.auth_link).to include '/auth/saml' }
    it { expect(provider.header_html).to be_blank }
    it { expect(provider.footer_html).to be_blank }
  end
end
