module Authentication
  def login_github_path
    '/auth/github'
  end

  def login_facebook_path
    '/auth/facebook'
  end

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

  def restricted_to_current_user(user)
    yield if user == current_user
  end

  def restricted_to_other_user(user)
    yield if current_user && user != current_user
  end

  def current_user_path
    user_path(current_user)
  end

  def validate_user
    render file: 'layouts/login' and return if must_login
    render_not_found unless from_auth0?
  end

  def render_not_found
    raise ActionController::RoutingError.new('Not Found') unless can_visit?
  end

  def can_visit?
    Organization.current.public? || logged_and_can_visit?
  end

  def logged_and_can_visit?
    current_user? && current_user.can_visit?(session[:atheneum_permissions])
  end

  def must_login
    Organization.current.private? && (!current_user? && !from_auth0?)
  end

  def from_auth0?
    params['controller'] == 'sessions' && params['action'] == 'callback'
  end

  def set_permissions
    session[:atheneum_permissions] = Mumukit::Auth::Token.new(env['omniauth.auth']['extra']['raw_info']).permissions('atheneum')
  end

  def login_anchor(options={})
    options[:title] ||= :sign_in

    session[:redirect_after_login] = request.fullpath

    %Q{<a href="#" class="#{options[:class]}" onclick="window.signin();">#{I18n.t(options[:title])}</a>}.html_safe
  end
end
