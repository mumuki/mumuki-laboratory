class SessionsController < ApplicationController
  Mumukit::Login.configure_session_controller! self

  def failure
    @error_msg = request.params['message']
  end

  private

  def destroy_session_user_uid!
    remember_me_token.clear!
  end

  def save_session_user_uid!(user)
    remember_me_token.value = user.remember_me_token
  end

end
