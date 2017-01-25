module WithAuthentication
  include Mumukit::Login::AuthenticationHelpers

  def current_user_uid
    @current_user_uid ||= remember_me_token.value.try do |token|
      User.where(remember_me_token: token).first.try(:uid)
    end
  end

  def login_button(options={})
    set_after_login_redirection!
    login_form.button_html I18n.t(:sign_in), options[:class]
  end
end

