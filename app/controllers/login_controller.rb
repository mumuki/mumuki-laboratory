class LoginController < ApplicationController
  Mumukit::Login.configure_login_controller! self

  skip_before_action :verify_authenticity_token, if: lambda { Rails.env.development? }
  skip_before_action :validate_user_profile!,
                     :validate_accepted_role_terms!,
                     :validate_active_organization!,
                     :redirect_to_proper_context!,
                     :ensure_restore_progress!,
                     :visit_organization!

  private

  def organization_name
    params[:organization] || super
  end

  def login_failure!
    redirect_to root_path, alert: request.params['message']
  end
end
