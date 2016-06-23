module Authorization
  def authorize!
    return if Organization.current.public?
    return if from_login_callback?

    render file: 'layouts/login' and return unless current_user?
    raise Exceptions::OrganizationPrivateError if !current_mode.can_visit?(current_user) && !from_logout?
  end
end
