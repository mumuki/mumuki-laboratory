module Mumuki::Laboratory::Controllers::Authorization
  def authorize_if_private!
    return if Organization.current.public? || from_sessions?
    authorize! :student
  end

  def authorization_slug
    Organization.current.slug
  end
end
