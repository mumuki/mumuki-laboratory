class UserMode::SamlAuthStrategy < UserMode::MultiUser
  def set_auth_provider(omniauth)
    omniauth.provider :saml,
      # TODO: change the :assertion_consumer_service_url:
      # =>  1. we can not call any Organization method since there is none instantiated yet and
      # =>  2. we must use the absolut path to generate the right SAML metadata to set up the federation with the IdP
      :assertion_consumer_service_url     => "http://central.#{Rails.configuration.domain}:3000/auth/saml/callback",
      :issuer                             => "Mumuki",
      :idp_sso_target_url                 => Rails.configuration.saml_idp_sso_target_url,
      :idp_cert                           => File.read('./saml.crt')
  end

  def protect_from_forgery(controller)
    # Do nothing (do not protect): the IdP calls the assertion_url via POST and without the CSRF token
  end

  def auth_link
    # Was using Organization.url_for('/auth/saml/') but the port got lost (is it a bug?)
    'href="http://central.' + Rails.configuration.domain + ':3000/auth/saml/"'
  end

end