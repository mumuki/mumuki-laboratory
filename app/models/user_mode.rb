module UserMode
  extend ConfigurableGlobal

  def self.get_current
    case Rails.configuration.auth_provider.downcase
      when 'developer'
        UserMode::SingleUser.new
      when 'saml'
        UserMode::SamlAuthStrategy.new
      when 'auth0'
        UserMode::Auth0AuthStrategy.new
      else
        raise "Unknown auth_strategy `#{auth_strategy}`"
    end
  end
end
