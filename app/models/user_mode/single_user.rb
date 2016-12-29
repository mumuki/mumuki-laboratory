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

  def logout_redirection_url(controller)
    controller.after_logout_redirection_url
  end

  def can_visit?(user)
    true
  end

  def html_badge
    ''
  end

  def auth_init_partial
    'layouts/auth_partials/null_partial.html.erb'
  end
end
