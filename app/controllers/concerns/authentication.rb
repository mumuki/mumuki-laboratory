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
    redirect_to :back, alert: "You must #{view_context.link_to('sign in with Github', login_path)} before continue" unless current_user?
  end
end