module Authentication
  def current_user_id
    remember_me_token.value.try do |token |
      User.where(remember_me_token: token).first.try(:id)
    end
  end

  def current_user?
    !current_user_id.nil?
  end

  def current_user
    User.find(current_user_id) if current_user?
  end

  def authenticate!
    unauthenticated! unless current_user?
  end

  def unauthenticated!
    message = t :you_must, action: login_anchor(title: :sign_in_action)

    redirect_to :back, alert: message
  rescue ActionController::RedirectBackError
    redirect_to root_path, alert: message
  end

  def current_user_path
    user_path(current_user)
  end

  def validate_user
    render file: 'layouts/login' and return if must_login
    render_not_found if !from_auth0?  && !can_visit?
  end

  def render_not_found
    raise ActionController::RoutingError.new('Not Found')
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
    Organization.current.private? && (!current_user? && !from_auth0?)
  end

  def from_auth0?
    params['controller'] == 'sessions' && params['action'] == 'callback'
  end

  def set_permissions
    current_mode.if_online do
      session[:atheneum_permissions] = Mumukit::Auth::Token.new(env['omniauth.auth']['extra']['raw_info']).permissions('atheneum').to_s
    end
  end

  def login_anchor(options={})
    options[:title] ||= :sign_in

    session[:redirect_after_login] = request.fullpath

    %Q{<a class="#{options[:class]}" #{current_mode.auth_link}>#{I18n.t(options[:title])}</a>}.html_safe
  end
end
