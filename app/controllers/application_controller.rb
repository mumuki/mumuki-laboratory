class ApplicationController < ActionController::Base
  include Authentication
  include Pagination

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :current_user?, :current_user_id, :login_path, :restricted_to_current_user
end
