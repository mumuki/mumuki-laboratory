module WithAuthorization
  def authorize!
    return if Organization.public?
    return if from_login_callback?

    Mumukit::Auth::Login.request_authentication!(self, Organization.login_settings) and return unless current_user?
    #FIXME we should use auth protect! here
    raise Exceptions::OrganizationPrivateError if !current_user.student? && !from_logout?
  end
end
