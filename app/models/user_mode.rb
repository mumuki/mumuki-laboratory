module UserMode
  extend ConfigurableGlobal
  def self.get_current
    if Rails.configuration.single_user_mode
      UserMode::SingleUser.new
    else
      case Rails.configuration.auth_provider.downcase
        when 'saml'
          UserMode::SamlAuthStrategy.new
        when 'auth0'
          UserMode::Auth0AuthStrategy.new
        else
          raise 'Unknown auth_strategy "#{auth_strategy}"'
        end
      end
  end
end