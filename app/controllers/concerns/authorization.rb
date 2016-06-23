module Authorization
  def authorize!
    return if Organization.current.public?
    return if from_login_callback?

    render file: 'layouts/login' and return unless current_user?
    raise Exceptions::OrganizationPrivateError if !current_user_can_visit? && !from_logout?
  end

  def current_user_can_visit?
    current_mode.if_offline do
      return true
    end

    current_user.student?
  end
end
