class SessionsController < ApplicationController
  include Mumukit::Login::SessionControllerHelpers

  def callback
    user = user_for_omniauth_profile

    remember_me_token.value = user.remember_me_token

    path = session[:redirect_after_login] || :back
    session[:redirect_after_login] = nil

    redirect_to path
  end

  def failure
    @error_msg = request.params['message']
  end

  def destroy
    remember_me_token.clear!
    redirect_to Mumukit::Login.logout_redirection_path
  end

end
