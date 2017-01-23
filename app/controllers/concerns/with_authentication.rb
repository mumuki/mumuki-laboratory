module WithAuthentication
  def current_user_id
    @current_user_id ||= remember_me_token.value.try do |token|
      User.where(remember_me_token: token).first.try(:id)
    end
  end

  def current_user?
    current_user_id.present?
  end

  def current_user
    @current_user ||= User.find(current_user_id) if current_user?
  end

  def authenticate!
    login_form.show! unless current_user?
  end

  def login_button(options={})
    session[:redirect_after_login] = request.fullpath
    login_form.button_html I18n.t(:sign_in), options[:class]
  end
end
