module Authorization
  def authorize!
    return if Organization.public?
    return if from_login_callback?

    # FIXME use login provider here
    render file: 'layouts/login' and return unless current_user?
    raise Exceptions::OrganizationPrivateError if !current_user.student? && !from_logout?
  end
end
