class LoginController < ApplicationController
  Mumukit::Login.configure_login_controller! self

  private

  def login_failure!
    @error_msg = request.params['message']
  end
end
