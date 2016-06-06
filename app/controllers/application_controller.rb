class ApplicationController < ActionController::Base
  include Authentication
  include Authorization
  include WithRememberMeToken
  include Pagination
  include Recurrence
  include Notifications
  include Accessibility
  include WithDynamicErrors

  before_action :set_organization
  before_action :set_locale
  before_action :authorize!
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

  private

  def set_locale
    I18n.locale = Organization.current.locale
  end


  def render_not_found
    raise ActionController::RoutingError.new('Not found')
  end

  def from_login_callback?
    from_sessions? && params['action'] == 'callback'
  end

  def from_logout?
    from_sessions? && params['action'] == 'destroy'
  end

  def from_sessions?
    params['controller'] == 'sessions'
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
