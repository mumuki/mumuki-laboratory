class ApplicationController < ActionController::Base
  include Authentication
  include WithRememberMeToken
  include Pagination
  include Recurrence
  include Notifications

  before_action :set_organization
  before_action :validate_user
  before_action :set_locale
  before_action :validate_subject_accessible!

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

  def render_not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def from_login_callback?
    params['controller'] == 'sessions' && params['action'] == 'callback'
  end

  def validate_subject_accessible!
    render_not_found if subject && !subject.used_in?(Organization.current)
  end

  def subject #TODO may be used to remove breadcrumbs duplication
    nil
  end

  def redirect_to_last_guide
    #redirect_to current_user.last_guide, notice: t(:welcome_back_after_redirection)
  end

  def set_organization
    Organization.find_by!(name: request.organization_name).switch!
  end
end
