module WithAuthentication
  include Mumukit::Login::AuthenticationHelpers

  def login_button(options={})
    login_form.button_html I18n.t(:sign_in), options[:class]
  end
end

