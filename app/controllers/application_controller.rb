class ApplicationController < ActionController::Base
  include Authentication
  include WithRememberMeToken
  include Pagination

  before_action :set_organization
  before_action :validate_user
  before_action :set_locale
  before_action :check_subject_accessible!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  current_mode.protect_from_forgery self

  helper_method :current_user, :current_user?,
                :current_user_id,
                :login_anchor,
                :comments_count,
                :has_comments?,
                :subject

  def set_locale
    I18n.locale = Organization.current.locale
  end

  private

  def check_subject_accessible!
    render_not_found if subject && !subject.used_in?(Organization.current)
  end

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

  def has_comments?
    comments_count > 0
  end

  def comments_count
    current_user.try(:unread_comments).try(:count) || 0
  end

  def redirect_to_last_guide
    #redirect_to current_user.last_guide, notice: t(:welcome_back_after_redirection)
  end

  def set_organization
    Organization.find_by!(name: request.organization_name).switch!
  end
end
