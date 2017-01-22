require 'spec_helper'

describe Mumukit::Login::Provider do
  let(:provider) { Mumukit::Auth.config.login_provider }

  it { expect(provider).to be_a Mumukit::Login::Provider::Developer }
  it { expect(provider.name).to eq 'developer' }

  describe Mumukit::Login::Provider::Developer do
    let(:provider) { Mumukit::Login::Provider::Developer.new }

    it { expect(provider.button_html('login', 'clazz')).to eq '<a class="clazz" href="/auth/developer">login</a>' }

    it { expect(provider.header_html).to be_blank }
    it { expect(provider.footer_html).to be_blank }
  end

  describe Mumukit::Login::Provider::Auth0 do
    let(:provider) { Mumukit::Login::Provider::Auth0.new }
    let(:login_settings) { Mumukit::Login::Settings.new }

    it { expect(provider.button_html('login', 'clazz')).to eq '<a class="clazz" href="#" onclick="window.signin();">login</a>' }
    it { expect(provider.header_html(login_settings)).to be_present }
    it { expect(provider.footer_html).to be_present }
  end

  describe Mumukit::Login::Provider::Saml do
    let(:provider) { Mumukit::Login::Provider::Saml.new }

    it { expect(provider.button_html('login', 'clazz')).to eq '<a class="clazz" href="/auth/saml">login</a>' }
    it { expect(provider.header_html).to be_blank }
    it { expect(provider.footer_html).to be_blank }
  end
end
