class ApplicationController < ActionController::Base
  Mumukit::Login.configure_controller! self

  protect_from_forgery with: :exception

  include Mumuki::Laboratory::Controllers::CurrentOrganization
  include Mumukit::Login::AuthenticationHelpers

  include Mumuki::Laboratory::Controllers::Authorization
  include Mumuki::Laboratory::Controllers::Disabling
  include Mumuki::Laboratory::Controllers::Notifications
  include Mumuki::Laboratory::Controllers::DynamicErrors
  include Mumuki::Laboratory::Controllers::EmbeddedMode
  include Mumuki::Laboratory::Controllers::IncognitoMode
  include Mumuki::Laboratory::Controllers::ActionRedirector

  before_action :set_current_organization!
  before_action :set_locale!

  before_action :ensure_user_enabled!, if: :current_user?
  before_action :validate_active_organization!

  before_action :redirect_to_proper_context!, if: :immersive_context_wrong?

  before_action :authorize_if_private!
  before_action :validate_active_organization!
  before_action :validate_user_profile!, if: :current_user?

  before_action :visit_organization!, if: :current_user?

  after_action :leave_organization!

  helper_method :current_workspace,
                :login_button,
                :notifications_count,
                :user_notifications_path,
                :has_notifications?,
                :subject,
                :should_choose_organization?,
                :theme_stylesheet_url,
                :extension_javascript_url

  def immersive_context_wrong?
    current_immersive_context != Organization.current
  end

  def redirect_to_proper_context!
    # TODO: redirect to subject (if it exists on the immersive context)
    redirect_to current_immersive_context.url_for('/')
  end

  def should_choose_organization?
    return false unless current_user?

    # TODO: replace `nil` with `subject` to consider exercise, guide, etc
    current_user.immersive_organizations_at(nil).size > 1
  end

  # ensures contents are accessible to current user
  def validate_accessible!
    return if current_user&.teacher_here?
    accessible_subject.validate_accessible_for! current_user
  end

  def validate_active_organization!
    return if current_user&.teacher_here?
    Organization.current.validate_active!
  end


  # required by Mumukit::Login
  def login_button(options = {})
    login_form.button_html I18n.t(:sign_in), options[:class]
  end

  # redirects to the usage in the current organization for the given content
  # or raises a not found error if unused
  def redirect_to_usage(content)
    raise Mumuki::Domain::NotFoundError unless content.usage_in_organization.try { |usage| redirect_to usage }
  end

  def current_workspace
    Mumuki::Domain::Workspace.new(current_user, Organization.current)
  end

  private

  def current_immersive_context
    # TODO: replace `nil` with `subject` to consider exercise, guide, etc
    current_user&.current_immersive_context_at(nil) || Organization.current
  end

  def from_sessions?
    params['controller'] == 'login'
  end

  def login_settings
    Organization.current.login_settings
  end

  def validate_user_profile!
    unless current_user.profile_completed?
      save_location_before! :profile_completion
      flash.notice = I18n.t :please_fill_profile_data
      redirect_to edit_user_path
    end
  end

  def set_locale!
    I18n.locale = Organization.current.locale
  end

  def subject #TODO may be used to remove breadcrumbs duplication
    nil
  end

  def leave_organization!
    Mumukit::Platform::Organization.leave!
  end
end
