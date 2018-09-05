class LoginController < ApplicationController
  Mumukit::Login.configure_login_controller! self

  private

  def organization_name
    params[:organization] || super
  end

  def login_failure!
    redirect_to root_path, alert: request.params['message']
  end
end
