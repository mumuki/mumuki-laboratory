require 'spec_helper'

describe UserMode do
  it { expect(UserMode.current).to be_a UserMode::MultiUser }

  it { expect(UserMode::SingleUser.new.auth_link).to include '/auth/developer' }
  it { expect(UserMode::Auth0AuthStrategy.new.auth_link).to include 'onclick' }
  it { expect(UserMode::SamlAuthStrategy.new.auth_link).to include '/auth/saml' }
end
