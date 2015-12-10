class ApplicationController < ActionController::Base
  include Authentication
  include WithRememberMeToken
  include Pagination

  before_action :set_locale

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :current_user?,
                :current_user_id,
                :current_user_path,
                :login_github_path, :login_facebook_path,
                :login_anchor,
                :restricted_to_author, :restricted_to_current_user,
                :restricted_to_other_user,
                :subject

  def set_locale
    I18n.locale = Tenant.current.locale
  end

  private

  def subject
    nil
  end
end
