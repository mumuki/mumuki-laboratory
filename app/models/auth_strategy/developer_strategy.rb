class AuthStrategy::DeveloperStrategy < AuthStrategy

  def set_auth_provider(omniauth)
    omniauth.provider :developer
  end

  def auth_link
    "href='/auth/developer'"
  end

  def protect_from_forgery(_controller)
  end
end
