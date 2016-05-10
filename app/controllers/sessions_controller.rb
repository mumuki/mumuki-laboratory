class SessionsController < ApplicationController
  def callback
    user = User.omniauth(env['omniauth.auth'])
    remember_me_token.value = user.remember_me_token

    redirect_after_login
  end

  def failure
    @error_msg = request.params['message']
  end

  def destroy
    remember_me_token.clear!
    redirect_to root_url
  end


  def redirect_after_login
    path = session[:redirect_after_login] || :back
    session[:redirect_after_login] = nil

    if should_redirect_to_last_guide? && path == root_path
      redirect_to_last_guide
    else
      redirect_to path
    end
  end
end