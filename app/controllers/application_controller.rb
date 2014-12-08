class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :current_user?, :current_user_id

  def current_user_id
    session[:user_id]
  end

  def current_user?
    !current_user_id.nil?
  end

  def current_user
    User.find(current_user_id) if current_user?
  end

  def authenticate!
    redirect_to :back, alert: "You must #{view_context.link_to('Sign in with Github', '/auth/github')} before continue" unless current_user?
  end

end
