class UserMode::MultiUser
  def set_auth_provider(omniauth)
    raise 'This method should be overwritten'
  end

  def auth_init_partial
    'layouts/auth_partials/null_partial.html.erb'
  end

  def html_badge
    ''
  end

  def auth_link
    raise 'This method should be overwritten'
  end

  def logo_url
    Organization.logo_url
  end

  def logout_redirection_url(controller)
    controller.after_logout_redirection_url
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
