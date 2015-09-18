class SessionsController < ApplicationController
  def create
    user = User.omniauth(env['omniauth.auth'])
    remember_me_token.value = user.remember_me_token

    redirect_to redirect_after_login_path
  end

  def destroy
    remember_me_token.clear!
    redirect_to root_url
  end

  private

  def redirect_after_login_path
    redirect_after_login = session[:redirect_after_login] || :back
    session[:redirect_after_login] = nil
    redirect_after_login
  end
end
