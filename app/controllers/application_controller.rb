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
                :restricted_to_author, :restricted_to_current_user

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { :locale => I18n.locale }
  end
end
