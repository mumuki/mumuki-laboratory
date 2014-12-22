module Authentication
  def login_path
    '/auth/github'
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
    message = "You must #{view_context.link_to('sign in with Github', login_path)} before continue"
    redirect_to :back, alert: message unless current_user?
  rescue ActionController::RedirectBackError
    redirect_to root_path, alert: message unless current_user?
  end

  def restricted_to_current_user(exercise)
    yield if exercise.authored_by? current_user
  end

end