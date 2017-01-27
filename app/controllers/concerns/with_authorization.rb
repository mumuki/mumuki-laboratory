module WithAuthorization
  def from_sessions?
    params['controller'] == 'login'
  end

  def authorize!
    return if Organization.public? || from_sessions?

    if current_user?
      current_user.permissions.protect! :student, Organization.slug
    else
      authenticate!
    end
  end
end
