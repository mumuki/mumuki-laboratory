class ApplicationController < ActionController::Base
  include Authentication
  include Pagination

  before_action :set_locale

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :current_user?, :current_user_id, :login_path, :restricted_to_current_user

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
