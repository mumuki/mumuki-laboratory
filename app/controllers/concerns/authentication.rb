module Authentication
  def login_path
    '/auth/github?next=' + request.fullpath
  end

  def current_user_id
    session[:user_id]
  end

  def current_user?
    !current_user_id.nil?
  end

  def current_user
    User.find(current_user_id) if current_user?
  end

  def authenticate!
    message = t :you_must, action: view_context.link_to(t(:sign_in_with_github_action), login_path)
    redirect_to :back, alert: message unless current_user?
  rescue ActionController::RedirectBackError
    redirect_to root_path, alert: message unless current_user?
  end

  def restricted_to_author(authored)
    yield if authored.authored_by? current_user
  end

  def restricted_to_current_user(user)
    yield if user == current_user
  end

  def restricted_to_other_user(user)
    yield if current_user && user != current_user
  end

  def current_user_path
    user_path(current_user)
  end
end
