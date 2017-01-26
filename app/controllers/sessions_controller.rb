class SessionsController < ApplicationController
  Mumukit::Login::Rails.configure_session_controller! self

  def login
    set_after_login_redirection!
    redirect_to_auth!
  end

  def callback
    user = user_for_omniauth_profile
    remember_me_token.value = user.remember_me_token
    redirect_after_login!
  end

  def failure
    @error_msg = request.params['message']
  end

  def destroy
    remember_me_token.clear!
    redirect_after_logout!
  end
end
