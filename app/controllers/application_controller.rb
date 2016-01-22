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
                :restricted_to_current_user,
                :restricted_to_other_user,
                :subject

  def set_locale
    I18n.locale = Book.current.locale
  end

  private

  def subject #TODO may be used to remove breadcrumbs duplication
    nil
  end

  def visitor_recurrent?
    current_user? && current_user.last_guide.present?
  end

  def visitor_comes_from_internet?
    !request_host_include? %w(mumuki localmumuki)
  end

  def request_host_include?(hosts)
    hosts.any? { |host| Addressable::URI.parse(request.referer).host.include? host } rescue false
  end

  def redirect_to_last_guide
    redirect_to current_user.last_guide, notice: t(:welcome_back_after_redirection)
  end
end
