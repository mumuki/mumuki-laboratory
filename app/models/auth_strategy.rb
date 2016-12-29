class AuthStrategy
  extend ConfigurableGlobal

  def protect_from_forgery(controller)
    controller.protect_from_forgery with: :exception
  end

  def logout_redirection_url(controller)
    controller.after_logout_redirection_url
  end

  def html_badge
    ''
  end

  def auth_init_partial
    'layouts/auth_partials/null_partial.html.erb'
  end

  def self.get_current
    auth_strategy = Rails.configuration.auth_provider.downcase
    case auth_strategy
      when 'developer'
        AuthStrategy::DeveloperStrategy.new
      when 'saml'
        AuthStrategy::SamlStrategy.new
      when 'auth0'
        AuthStrategy::Auth0Strategy.new
      else
        raise "Unknown auth_strategy `#{auth_strategy}`"
    end
  end
end
