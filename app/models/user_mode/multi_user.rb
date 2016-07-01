class UserMode::MultiUser

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

  def logo_url
    Organization.logo_url
  end

  def protect_from_forgery(controller)
    controller.protect_from_forgery with: :exception
  end

  def can_visit?(user)
    user.student?
  end

  def if_multiuser
    yield
  end

end
