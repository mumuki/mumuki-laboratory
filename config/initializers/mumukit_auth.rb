module Mumukit::Auth::Login

  ##########################
  ## Server configuration ##
  ##########################


  # Configures forgery protection.
  # This method is Rails-specific
  #
  # @param [ActionController] action_controller
  #
  def self.configure_forgery_protection!(action_controller)
    provider.configure_forgery_protection!(action_controller)
  end

  # Configures omniauth. This method typically configures
  # and sets the omniauth provider. Typical config should look like this
  #
  #   Rails.application.config.middleware.use OmniAuth::Builder do
  #    Mumukit::Auth::Login.configure_omniauth! self
  #   end
  #
  # @param [OmniAuth::Builder] omniauth
  #
  def self.configure_omniauth!(omniauth)
    provider.configure_omniauth! omniauth
  end

  ############
  ## Routes ##
  ############

  # Path - relative to current domain - to which
  # app must redirect after a successful logout
  #
  # This is not the same as the logout callback - this route
  # should point to a safe point that won't fail without authentication with
  # a visual message to the user stating that she
  # has logged out
  #
  def self.logout_redirection_path
    provider.logout_redirection_path
  end

  #######################
  ## Visual components ##
  #######################

  def self.header_html
    provider.header_html
  end

  def self.button_html(title, clazz)
    %Q{<a class="#{clazz}" #{provider.auth_link}>#{title}</a>}.html_safe
  end

  def self.footer_html
    provider.footer_html
  end

  private

  def self.provider
    Mumukit::Auth.config.login_provider
  end
end

module Mumukit::Auth::LoginProvider
  def self.from_env
    parse_login_provider(login_provider_string)
  end

  def self.login_provider_string
    if ENV['MUMUKI_LOGIN_PROVIDER'].blank? || ENV['RACK_ENV'] == 'test' || ENV['RAILS_ENV'] == 'test'
      'developer'
    else
      ENV['MUMUKI_LOGIN_PROVIDER']
    end
  end

  def self.parse_login_provider(login_provider)
    case login_provider
      when 'developer'
        Mumukit::Auth::LoginProvider::Developer.new
      when 'saml'
        Mumukit::Auth::LoginProvider::Saml.new
      when 'auth0'
        Mumukit::Auth::LoginProvider::Auth0.new
      else
        raise "Unknown login_provider `#{login_provider}`"
    end
  end
end

class Mumukit::Auth::LoginProvider::Base
  def configure_forgery_protection!(action_controller)
    action_controller.protect_from_forgery with: :exception
  end

  def logout_redirection_path
    '/'
  end

  def footer_html
    nil
  end

  def header_html
    nil
  end
end

class Mumukit::Auth::LoginProvider::Saml < Mumukit::Auth::LoginProvider::Base
  def configure_omniauth!(omniauth)
    File.open('./saml.crt', 'w') { |file| file.write(Rails.configuration.saml_idp_cert.gsub("\\n", "\n")) }
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
                      idp_cert: File.read('./saml.crt'),
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

  def configure_forgery_protection!(_action_controller)
    # FIXME this is big security issue
    # Do nothing (do not protect): the IdP calls the assertion_url via POST and without the CSRF token
  end

  def auth_link
    "href='/auth/saml/'"
  end

  def logout_redirection_path
    '/auth/saml/spslo'
  end
end

class Mumukit::Auth::LoginProvider::Auth0 < Mumukit::Auth::LoginProvider::Base
  def configure_omniauth!(omniauth)
    omniauth.provider :auth0,
                      Rails.configuration.auth0_client_id,
                      Rails.configuration.auth0_client_secret,
                      Rails.configuration.auth0_domain,
                      callback_path: '/auth/auth0/callback'
  end

  def auth_link
    'href="#" onclick="window.signin();"'
  end

  def header_html
    #FIXME auth_callback_url is not available here
    #FIXME remove rails settings
    #FIXME remove organization reference
    html = <<HTML
<script src="https://cdn.auth0.com/js/lock-7.12.min.js"></script>
<script type="text/javascript">
var lock = new Auth0Lock('#{Rails.configuration.auth0_client_id}', '#{Rails.configuration.auth0_domain}');
function signin() {
  lock.show(#{Organization.login_settings.to_lock_json(auth_callback_url(:auth0))});
}
</script>
HTML
    html.html_safe
  end

  def footer_html
    '<a href="https://auth0.com/" target="_blank">
        <img height="40" alt="JWT Auth for open source projects" src="//cdn.auth0.com/oss/badges/a0-badge-light.png"/>
     </a>'.html_safe
  end
end

class Mumukit::Auth::LoginProvider::Developer < Mumukit::Auth::LoginProvider::Base
  def configure_omniauth!(omniauth)
    omniauth.provider :developer
  end

  def auth_link
    #FIXME this is not a link
    "href='/auth/developer'"
  end

  def configure_forgery_protection!(_)
  end
end

class PostgresPermissionsPersistence
  def self.from_config
    new
  end

  def set!(uid, permissions)
    User.find_by(uid: uid).update!(permissions: permissions)
  end

  def get(uid)
    User.find_by(uid: uid)&.permissions || Mumukit::Auth::Permissions.parse({})
  end

  def close
  end

  def clean_env!
  end
end


Mumukit::Auth.configure do |c|
  c.login_provider = Mumukit::Auth::LoginProvider.from_env
  c.persistence_strategy = PostgresPermissionsPersistence.new

  # TODO remove those lines
  unless Rails.env.test?
    c.client_id = Rails.configuration.auth0_client_id
    c.client_secret = Rails.configuration.auth0_client_secret
  end
end
