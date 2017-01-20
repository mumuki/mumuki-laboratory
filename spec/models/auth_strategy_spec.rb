require 'spec_helper'

describe Mumukit::Auth::LoginProvider do
  it { expect(Mumukit::Auth.config.login_provider).to be_a Mumukit::Auth::LoginProvider::Developer }

  it { expect(Mumukit::Auth::LoginProvider::Developer.new.auth_link).to include '/auth/developer' }
  it { expect(Mumukit::Auth::LoginProvider::Developer.new.html_badge).to be_blank }

  it { expect(Mumukit::Auth::LoginProvider::Auth0.new.auth_link).to include 'onclick' }
  it { expect(Mumukit::Auth::LoginProvider::Auth0.new.html_badge).to be_present }

  it { expect(Mumukit::Auth::LoginProvider::Saml.new.auth_link).to include '/auth/saml' }
  it { expect(Mumukit::Auth::LoginProvider::Saml.new.html_badge).to be_blank }
end
