module WithAuthorization
  def from_sessions?
    params['controller'] == 'login'
  end

  def authorize_if_private!
    return if Organization.public? || from_sessions?
    authorize! :student
  end

  def authorization_slug
    Organization.current.slug
  end
end
