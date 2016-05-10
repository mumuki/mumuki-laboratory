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

  def login_anchor(options={})
    options[:title] ||= :sign_in

    session[:redirect_after_login] = request.fullpath

    link = if Rails.configuration.offline_mode
      then 'href="auth/developer"'
      else 'href="#" onclick="window.signin();"'
      end

    %Q{<a class="#{options[:class]}" #{link}>#{I18n.t(options[:title])}</a>}.html_safe
  end
end
