require 'spec_helper'

describe AuthStrategy do
  it { expect(AuthStrategy.current).to be_a AuthStrategy::DeveloperStrategy }

  it { expect(AuthStrategy::DeveloperStrategy.new.auth_link).to include '/auth/developer' }
  it { expect(AuthStrategy::DeveloperStrategy.new.html_badge).to be_blank }

  it { expect(AuthStrategy::Auth0Strategy.new.auth_link).to include 'onclick' }
  it { expect(AuthStrategy::Auth0Strategy.new.html_badge).to be_present }

  it { expect(AuthStrategy::SamlStrategy.new.auth_link).to include '/auth/saml' }
  it { expect(AuthStrategy::SamlStrategy.new.html_badge).to be_blank }
end
