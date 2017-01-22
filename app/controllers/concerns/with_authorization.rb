module WithAuthorization
  def authorize!
    return if Organization.public?
    return if from_login_callback?

    login_form.show! and return unless current_user?
    #FIXME we should use auth protect! here
    raise Exceptions::OrganizationPrivateError if !current_user.student? && !from_logout?
  end
end
