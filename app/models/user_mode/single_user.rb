class UserMode::SingleUser

  def set_auth_provider(omniauth)
    omniauth.provider :developer
  end

  def auth_link
    "href='/auth/developer'"
  end

  def protect_from_forgery(controller)
    # not needed!
  end

  def logo_url
    'logo-alt-large.png'
  end

  def can_visit?(user)
    true
  end

  def if_multiuser
  end
end
