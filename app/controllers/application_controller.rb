class ApplicationController < ActionController::Base
  include WithOrganization

  include WithAuthentication
  include WithAuthorization
  include WithRememberMeToken
  include WithPagination
  include WithReferer
  include WithComments
  include Accessible
  include WithDynamicErrors
  include WithOrganizationChooser

  before_action :set_organization!
  before_action :set_locale!
  before_action :authorize!
  before_action :validate_subject_accessible!
  before_action :visit_organization!, if: :current_user?

  Mumukit::Login::Rails.configure_controller! self

  helper_method :login_button,
                :comments_count,
                :has_comments?,
                :subject,
                :should_choose_organization?,

  private

  def login_settings
    Organization.login_settings
  end

  def set_locale!
    I18n.locale = Organization.locale
  end

  def subject #TODO may be used to remove breadcrumbs duplication
    nil
  end
end
