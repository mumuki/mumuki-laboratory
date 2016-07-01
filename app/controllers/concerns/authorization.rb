module Authorization
  def authorize!
    return if Organization.public?
    return if from_login_callback?

    render file: 'layouts/login' and return unless current_user?
    raise Exceptions::OrganizationPrivateError if !UserMode.can_visit?(current_user) && !from_logout?
  end
end
