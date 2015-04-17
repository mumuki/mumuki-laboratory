class ApplicationController < ActionController::Base
  include Authentication
  include Pagination

  before_action :set_locale

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :current_user?,
                :current_user_id,
                :current_user_path, :login_path,
                :restricted_to_author, :restricted_to_current_user,
                :restricted_to_other_user

  def set_locale
    I18n.locale = params[:locale] || extract_locale_from_accept_language_header || I18n.default_locale
  end

  def default_url_options
    { :locale => I18n.locale }
  end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
end
