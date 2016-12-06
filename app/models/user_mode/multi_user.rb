class UserMode::MultiUser

  def initialize(auth_strategy)
    @auth_strategy=case auth_strategy.downcase
      when 'saml'
        SamlAuthStrategy.new
      when 'auth0'
        Auth0AuthStrategys.new
      else
        raise 'Unknown auth_strategy "#{auth_strategy}"'
      end
  end

  def set_auth_provider(omniauth)
    @auth_strategy.set_auth_provider omniauth
  end

  def auth_init_partial
    @auth_strategy.init_partial
  end

  def html_badge
    @auth_strategy.html_badge
  end

  def auth_link
    @auth_strategy.auth_link
  end

  def logo_url
    Organization.logo_url
  end

  def protect_from_forgery(controller)
    if @auth_strategy.should_be_forgery_protected?
      controller.protect_from_forgery with: :exception
    end
  end

  def can_visit?(user)
    user.student?
  end

  def if_multiuser
    yield
  end

end
