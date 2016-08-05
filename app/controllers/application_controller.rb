class ApplicationController < ActionController::Base
  include WithOrganization

  include Authentication
  include Authorization
  include WithRememberMeToken
  include Pagination
  include Referer
  include Recurrence
  include WithComments
  include Accessibility
  include WithDynamicErrors
  include WithRedirect

  before_action :set_organization!
  before_action :set_locale!
  before_action :authorize!
  before_action :validate_subject_accessible!
  before_action :visit_organization!, if: :current_user?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  UserMode.protect_from_forgery self

  helper_method :current_user, :current_user?,
                :current_user_id,
                :login_anchor,
                :comments_count,
                :has_comments?,
                :subject,
                :ask_redirect?

  private

  def set_locale!
    I18n.locale = Organization.locale
  end

  def subject #TODO may be used to remove breadcrumbs duplication
    nil
  end

  def redirect_to_last_guide
    #redirect_to current_user.last_guide, notice: t(:welcome_back_after_redirection)
  end
end
