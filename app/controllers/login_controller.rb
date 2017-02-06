class LoginController < ApplicationController
  Mumukit::Login.configure_login_controller! self

  private

  def login_failure!
    @error_msg = request.params['message']
  end

  #
  # def destroy_current_user_session!
  #   remember_me_token.clear!
  # end
  #
  # def save_current_user_session!(user)
  #   remember_me_token.value = user.remember_me_token
  # end
end
