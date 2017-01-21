module Mumukit::Auth::Login

  ##########################
  ## Server configuration ##
  ##########################

  # Configures the login routes.
  # This method is rails-specific, and should be used this way:
  #
  #  controller :sessions do
  #    Mumukit::Auth::Login.configure_session_controller_routes! self
  #  end
  #
  # @param [RailsRouter] rails_router
  #
  def self.configure_session_controller_routes!(rails_router)
    rails_router.match 'auth/:provider/callback' => :callback, via: [:get, :post], as: 'auth_callback'
    rails_router.get 'auth/failure' => :failure
    rails_router.get 'logout' => :destroy
  end

  # Configures forgery protection.
  # This method is Rails-specific
  #
  # @param [ActionController::Class] controller_class
  #
  def self.configure_forgery_protection!(controller_class)
    provider.configure_forgery_protection!(controller_class)
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

  # HTML <HEAD> customizations. Send this message
  # in order to add login provider-specific code - like CSS and JS -
  # to your page header
  #
  # @param [Mumukit::Auth::LoginSettings] login_settings
  #
  def self.header_html(login_settings)
    provider.header_html(login_settings)
  end

  def self.button_html(title, clazz)
    provider.button_html title, clazz
  end

  def self.footer_html
    provider.footer_html
  end

  def self.request_authentication!(controller, login_settings)
    provider.request_authentication!(controller, login_settings)
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
  def name
    @name ||= self.class.name.demodulize.downcase
  end

  required :configure_omniauth!

  def configure_forgery_protection!(action_controller)
    action_controller.protect_from_forgery with: :exception
  end

  def request_authentication!(controller, *)
    controller.redirect auth_path
  end

  def auth_path
    "/auth/#{name}"
  end

  def callback_path
    "/auth/#{name}/callback"
  end

  def logout_redirection_path
    '/'
  end

  def button_html(title, clazz)
    %Q{<a class="#{clazz}" href="#{auth_path}">#{title}</a>}.html_safe
  end

  def footer_html
    nil
  end

  def header_html(*)
    nil
  end
end

class Mumukit::Auth::LoginProvider::Saml < Mumukit::Auth::LoginProvider::Base
  def saml_config
    @saml_config ||= struct base_url: ENV['MUMUKI_SAML_BASE_URL'],
                            idp_sso_target_url: ENV['MUMUKI_SAML_IDP_SSO_TARGET_URL'],
                            idp_slo_target_url: ENV['MUMUKI_SAML_IDP_SLO_TARGET_URL'],
                            translation_name: ENV['MUMUKI_SAML_TRANSLATION_NAME'] || 'name',
                            translation_email: ENV['MUMUKI_SAML_TRANSLATION_EMAIL'] || 'email',
                            translation_image: ENV['MUMUKI_SAML_TRANSLATION_IMAGE'] || 'image'
  end


  def configure_omniauth!(omniauth)
    #FIXME is this file here ok?
    File.open('./saml.crt', 'w') { |file| file.write(Rails.configuration.saml_idp_cert.gsub("\\n", "\n")) }
    omniauth.provider :saml,
                      # TODO: change the :assertion_consumer_service_url, the :issuer and the :slo_default_relay_state:
                      # =>  1. we can not call any Organization method since there is none instantiated yet and
                      # =>  2. we must use the absolut path to generate the right SAML metadata to set up the federation with the IdP
                      assertion_consumer_service_url: "#{saml_config.base_url}#{callback_path}",
                      single_logout_service_url: "#{saml_config.base_url}#{auth_path}/slo",
                      issuer: "#{saml_config.base_url}#{auth_path}",
                      idp_sso_target_url: saml_config.idp_sso_target_url,
                      idp_slo_target_url: saml_config.idp_slo_target_url,
                      slo_default_relay_state: saml_config.base_url,
                      idp_cert: File.read('./saml.crt'),
                      attribute_service_name: 'Mumuki',
                      request_attributes: [
                        {name: 'email', name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic', friendly_name: 'Email address'},
                        {name: 'name', name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic', friendly_name: 'Full name'},
                        {name: 'image', name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic', friendly_name: 'Avatar image'}
                      ],
                      attribute_statements: {
                        name: [saml_config.translaton_name],
                        email: [saml_config.translaton_email],
                        image: [saml_config.translaton_image]
                      }
  end

  def configure_forgery_protection!(_action_controller)
    # FIXME this is big security issue
    # Do nothing (do not protect): the IdP calls the assertion_url via POST and without the CSRF token
  end

  def logout_redirection_path
    "#{auth_path}/spslo"
  end
end

class Mumukit::Auth::LoginProvider::Auth0 < Mumukit::Auth::LoginProvider::Base
  def auth0_config
    @auth0_config ||= struct client_id: Rails.configuration.auth0_client_id,
                             client_secret: Rails.configuration.auth0_client_secret,
                             domain: Rails.configuration.auth0_domain
  end

  def configure_omniauth!(omniauth)
    omniauth.provider :auth0,
                      auth0_config.client_id,
                      auth0_config.client_secret,
                      auth0_config.domain,
                      callback_path: callback_path
  end

  def button_html(title, clazz)
    %Q{<a class="#{clazz}" href="#" onclick="window.signin();">#{title}</a>}.html_safe
  end

  def request_authentication!(controller, login_settings)
    lock_settings = login_settings.to_lock_json(callback_path, closable: false)
    html = <<HTML
<script type="text/javascript">
    new Auth0Lock('#{auth0_config.client_id}', '#{auth0_config.domain}').show(#{lock_settings});
</script>
HTML
    render html: html.html_safe
  end

  def header_html(login_settings)
    lock_settings = login_settings.to_lock_json(callback_path)
    html = <<HTML
<script src="https://cdn.auth0.com/js/lock-7.12.min.js"></script>
<script type="text/javascript">
var lock = new Auth0Lock('#{auth0_config.client_id}', '#{auth0_config.domain}');
function signin() {
  lock.show(#{lock_settings});
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

  def configure_forgery_protection!(*)
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
