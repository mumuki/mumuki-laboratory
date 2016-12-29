class UserMode::Auth0AuthStrategy < UserMode
  def set_auth_provider(omniauth)
    omniauth.provider :auth0,
                      Rails.configuration.auth0_client_id,
                      Rails.configuration.auth0_client_secret,
                      Rails.configuration.auth0_domain,
                      callback_path: '/auth/auth0/callback'
  end

  def auth_link
    'href="#" onclick="window.signin();"'
  end

  def auth_init_partial
    'layouts/auth_partials/auth0.init.html.erb'
  end

  def html_badge
    '<a href="https://auth0.com/" target="_blank"><img height="40" alt="JWT Auth for open source projects" src="//cdn.auth0.com/oss/badges/a0-badge-light.png"/></a>'.html_safe
  end
end
