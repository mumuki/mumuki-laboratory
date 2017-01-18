class AuthStrategy::SamlStrategy < AuthStrategy
  def set_auth_provider(omniauth)
    omniauth.provider :saml,
                      # TODO: change the :assertion_consumer_service_url, the :issuer and the :slo_default_relay_state:
                      # =>  1. we can not call any Organization method since there is none instantiated yet and
                      # =>  2. we must use the absolut path to generate the right SAML metadata to set up the federation with the IdP
                      assertion_consumer_service_url: "#{Rails.configuration.saml_base_url}/auth/saml/callback",
                      single_logout_service_url: "#{Rails.configuration.saml_base_url}/auth/saml/slo",
                      issuer: "#{Rails.configuration.saml_base_url}/auth/saml",
                      idp_sso_target_url: Rails.configuration.saml_idp_sso_target_url,
                      idp_slo_target_url: Rails.configuration.saml_idp_slo_target_url,
                      slo_default_relay_state: Rails.configuration.saml_base_url,
                      idp_cert: Rails.configuration.saml_idp_cert || File.read('./saml.crt'),
                      attribute_service_name: 'Mumuki',
                      request_attributes: [
                        {name: 'email', name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic', friendly_name: 'Email address'},
                        {name: 'name', name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic', friendly_name: 'Full name'},
                        {name: 'image', name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic', friendly_name: 'Avatar image'}
                      ],
                      attribute_statements: {
                        name: [Rails.configuration.saml_translation_name || "name"],
                        email: [Rails.configuration.saml_translation_email || "email"],
                        image: [Rails.configuration.saml_translation_image || "image"]
                      }
  end

  def auth_link
    "href='/auth/saml/'"
  end

  def protect_from_forgery(controller)
    # FIXME this is big security issue
    # Do nothing (do not protect): the IdP calls the assertion_url via POST and without the CSRF token
  end

  def logout_redirection_url(controller)
    Organization.url_for('/auth/saml/spslo')
  end
end
