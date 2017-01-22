module WithAuthorization
  def authorize!
    return if Organization.public?
    return if from_login_callback?

    Mumukit::Login.request_authentication!(mumukit_controller, Organization.login_settings) and return unless current_user?
    #FIXME we should use auth protect! here
    raise Exceptions::OrganizationPrivateError if !current_user.student? && !from_logout?
  end
end
