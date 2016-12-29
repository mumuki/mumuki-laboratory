class UserMode
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
