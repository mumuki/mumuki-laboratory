module Authorization
  def authorize!
    render file: 'layouts/login' and return if must_login
    raise Exceptions::OrganizationPrivateException if !from_login_callback? && !can_visit? && !from_logout?
  end

  def can_visit?
    Organization.current.public? || logged_and_can_visit?
  end

  def logged_and_can_visit?
    current_mode.if_offline do
      return current_user?
    end

    current_user? && current_user.student?
  end

  def must_login
    Organization.current.private? && !current_user? && !from_login_callback?
  end
end
