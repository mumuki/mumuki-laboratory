module Authorization
  def authorize!
    render file: 'layouts/login' and return if must_login
    render_not_found if !from_login_callback?  && !can_visit?
  end

  def can_visit?
    Organization.current.public? || logged_and_can_visit?
  end

  def logged_and_can_visit?
    current_mode.if_offline do
      return current_user?
    end

    current_user? && current_user.can_visit?(session[:atheneum_permissions])
  end

  def must_login
    Organization.current.private? && !current_user? && !from_login_callback?
  end

  def set_permissions
    current_mode.if_online do
      session[:atheneum_permissions] = Mumukit::Auth::Token.from_env(env).permissions('atheneum').to_s
    end
  end
end