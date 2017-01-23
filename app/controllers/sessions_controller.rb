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
    # TODO: desharcode URL
    # TODO: redirect to /spslo ONLY if using saml_auth_strategy. Otherwise, redirect to root_url
    redirect_to AuthStrategy.logout_redirection_url self
  end

  def after_logout_redirection_url
    root_url
  end

  def redirect_after_login
    path = session[:redirect_after_login] || :back
    session[:redirect_after_login] = nil

    redirect_to path
  end
end
