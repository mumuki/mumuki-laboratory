require 'addressable/uri'

module Mumukit::Login
  def self.configure
    @config ||= defaults
    yield @config
  end

  def self.defaults
    struct.tap do |config|
      config.provider = Mumukit::Login::Provider.from_env
      config.saml = struct base_url: ENV['MUMUKI_SAML_BASE_URL'],
                           idp_sso_target_url: ENV['MUMUKI_SAML_IDP_SSO_TARGET_URL'],
                           idp_slo_target_url: ENV['MUMUKI_SAML_IDP_SLO_TARGET_URL'],
                           translation_name: ENV['MUMUKI_SAML_TRANSLATION_NAME'] || 'name',
                           translation_email: ENV['MUMUKI_SAML_TRANSLATION_EMAIL'] || 'email',
                           translation_image: ENV['MUMUKI_SAML_TRANSLATION_IMAGE'] || 'image'
      config.auth0 = struct client_id: ENV['MUMUKI_AUTH0_CLIENT_ID'],
                            client_secret: ENV['MUMUKI_AUTH0_CLIENT_SECRET'],
                            domain: ENV['MUMUKI_AUTH0_DOMAIN']
    end
  end

  def self.config
    @config
  end
end

class Mumukit::Login::Settings
  LOCK_LOGIN_METHODS = {
    facebook: 'facebook',
    github: 'github',
    google: 'google-oauth2',
    twitter: 'twitter',
    user_pass: 'Username-Password-Authentication'
  }

  attr_accessor :login_methods

  def initialize(login_methods = Mumukit::Login::Settings.default_methods)
    @login_methods = login_methods.map(&:to_sym)
  end

  def many_methods?
    user_pass? && social_login_methods.size > 1
  end

  def user_pass?
    login_methods.include? :user_pass
  end

  def social_login_methods
    login_methods - [:user_pass]
  end

  def to_lock_json(callback_url, options={})
    lock_json
      .merge(callbackURL: callback_url, responseType: 'code', authParams: {scope: 'openid profile'})
      .merge(options)
      .to_json
      .html_safe
  end

  def lock_json
    {dict: I18n.locale,
     connections: lock_login_methods,
     icon: '/logo-alt.png',
     socialBigButtons: !many_methods?,
     disableResetAction: false}
  end

  def lock_login_methods
    login_methods.map { |it| LOCK_LOGIN_METHODS[it] }
  end

  def self.login_methods
    LOCK_LOGIN_METHODS.keys
  end

  def self.default_methods
    [:user_pass]
  end
end

class Mumukit::Login::OriginRedirector
  def initialize(controller)
    @controller = controller
  end

  def redirect!
    @controller.redirect!(@controller.session[:redirect_after_login] || '/')
  end

  def save_location!
    @controller.session[:redirect_after_login] = Addressable::URI.heuristic_parse(origin).path
  end

  private

  def origin
    @controller.request.params['origin']
  end
end


class Mumukit::Login::Controller
  delegate :env, :redirect!, :render_html!, to: :@framework

  def initialize(framework)
    @framework = framework
  end

  def request
    Rack::Request.new(env)
  end

  def url_for(path)
    URI.join(request.base_url, path).to_s
  end

  def session
    request.session
  end

  class RailsFramework

    # @param [ActionController::Base] rails_controller
    def initialize(rails_controller)
      @rails_controller = rails_controller
    end

    def env
      @rails_controller.request.env
    end

    def redirect!(path)
      @rails_controller.redirect_to path
    end

    def render_html!(content)
      @rails_controller.render html: content.html_safe, layout: true
    end
  end
end

class Mumukit::Login::Form

  #######################
  ## Visual components ##
  #######################

  # This object will configure the login button using the given login settings
  # customizations, if possible
  #
  # @param [Mumukit::Login::Controller] controller a Mumukit::Login::Controller
  # @param [Mumukit::Login::Settings] login_settings customizations for the login UI
  def initialize(provider, controller, login_settings)
    @provider = provider
    @controller = controller
    @login_settings = login_settings
  end

  # HTML <HEAD> customizations. Send this message
  # in order to add login provider-specific code - like CSS and JS -
  # to your page header.
  #
  def header_html
    @provider.header_html(@controller, @login_settings)&.html_safe
  end

  def button_html(title, clazz)
    @provider.button_html(@controller, title, clazz)&.html_safe
  end

  def footer_html
    @provider.footer_html(@controller)&.html_safe
  end

  ###############################
  ## Triggering Authentication ##
  ###############################

  # Ask the user for authentication, by either rendering
  # the login form or redirecting to it
  #
  # This method should be called from a controller action
  # or action filter.
  #
  def show!
    @provider.request_authentication!(@controller, @login_settings)
  end
end

module Mumukit::Login::Rails

  # Configures the login routes.
  # This method should be used this way:
  #
  #  controller :sessions do
  #    Mumukit::Login.configure_session_controller_routes! self
  #  end
  #
  # @param [RailsRouter] rails_router
  #
  def self.configure_session_routes!(rails_router)
    rails_router.match 'auth/:provider/callback' => :callback, via: [:get, :post], as: 'auth_callback'
    rails_router.get 'auth/failure' => :failure
    rails_router.get 'logout' => :destroy
    rails_router.get 'login' => :login
  end

  def self.configure_session_controller!(controller_class)
    controller_class.class_eval do
      include Mumukit::Login::SessionControllerHelpers
    end
  end

  # Configures forgery protection and mixes authentication methods.
  #
  # @param [ActionController::Base::Class] controller_class
  #
  def self.configure_controller!(controller_class)
    Mumukit::Login.config.provider.configure_rails_forgery_protection!(controller_class)
    controller_class.class_eval do
      include Mumukit::Login::AuthenticationHelpers

      helper_method :current_user,
                    :current_user?,
                    :current_user_uid,
                    :mumukit_controller,
                    :login_form

      private

      def mumukit_controller
        Mumukit::Login::Controller.new Mumukit::Login::Controller::RailsFramework.new(self)
      end
    end
  end
end

module Mumukit::Login

  ##########
  ## Form ##
  ##########

  # Creates a new Mumukit::Login::Form using the
  # global Mumukit::Login.config.login_provider.
  #
  # @param [Mumukit::Login::Controller] controller
  # @param [Mumukit::Login::Settings] login_settings
  def self.new_form(controller, login_settings)
    Mumukit::Login::Form.new(provider, controller, login_settings)
  end


  #############
  ## Profile ##
  #############

  def self.normalized_omniauth_profile(omniauth)
    struct provider: omniauth.provider,
           name: omniauth.info.nickname || omniauth.info.name,
           social_id: omniauth.uid,
           email: omniauth.info.email,
           uid: omniauth.info.email || omniauth.uid,
           image_url: omniauth.info.image
  end


  # Configures omniauth. This method typically configures
  # and sets the omniauth provider. Typical config should look like this
  #
  #   Rails.application.config.middleware.use OmniAuth::Builder do
  #    Mumukit::Login.configure_omniauth! self
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

  def self.auth_path
    provider.auth_path
  end

  private

  def self.provider
    Mumukit::Login.config.provider
  end
end

module Mumukit::Login::Provider
  def self.from_env
    parse_login_provider(login_provider_string).tap do |provider|
      puts "[Mumukit::Login] Using #{provider} as login provider"
    end
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
        Mumukit::Login::Provider::Developer.new
      when 'saml'
        Mumukit::Login::Provider::Saml.new
      when 'auth0'
        Mumukit::Login::Provider::Auth0.new
      else
        raise "Unknown login_provider `#{login_provider}`"
    end
  end
end

class Mumukit::Login::Provider::Base
  def name
    @name ||= self.class.name.demodulize.downcase
  end

  required :configure_omniauth!

  def configure_rails_forgery_protection!(action_controller)
    action_controller.protect_from_forgery with: :exception
  end

  def request_authentication!(controller, *)
    controller.redirect! login_path(controller)
  end

  def login_path(controller)
    "/login?origin=#{controller.request.path}"
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

  def button_html(controller, title, clazz)
    %Q{<a class="#{clazz}" href="#{login_path(controller)}">#{title}</a>}
  end

  def footer_html(*)
    nil
  end

  def header_html(*)
    nil
  end
end

class Mumukit::Login::Provider::Saml < Mumukit::Login::Provider::Base
  def saml_config
    Mumukit::Login.config.saml
  end

  def configure_omniauth!(omniauth)
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

  def configure_rails_forgery_protection!(_controller_class)
    # FIXME this is big security issue
    # Do nothing (do not protect): the IdP calls the assertion_url via POST and without the CSRF token
  end

  def logout_redirection_path
    "#{auth_path}/spslo"
  end
end

class Mumukit::Login::Provider::Auth0 < Mumukit::Login::Provider::Base
  def configure_omniauth!(omniauth)
    omniauth.provider :auth0,
                      auth0_config.client_id,
                      auth0_config.client_secret,
                      auth0_config.domain,
                      callback_path: callback_path
  end

  def request_authentication!(controller, login_settings)
    settings = lock_settings(controller, login_settings, {closable: false})
    controller.render_html! <<HTML
 <script type="text/javascript">
      new Auth0Lock('#{auth0_config.client_id}', '#{auth0_config.domain}').show(#{settings});
  </script>
HTML
  end

  def header_html(*)
    <<HTML
<script src="https://cdn.auth0.com/js/lock-7.12.min.js"></script>
</script>
HTML
  end

  def footer_html(*)
    '<a href="https://auth0.com/" target="_blank">
        <img height="40" alt="JWT Auth for open source projects" src="//cdn.auth0.com/oss/badges/a0-badge-light.png"/>
     </a>'
  end

  private

  def auth0_config
    Mumukit::Login.config.auth0
  end

  def lock_settings(controller, login_settings, options)
    login_settings.to_lock_json(controller.url_for(callback_path), options)
  end
end

class Mumukit::Login::Provider::Developer < Mumukit::Login::Provider::Base
  def configure_omniauth!(omniauth)
    omniauth.provider :developer
  end

  def configure_rails_forgery_protection!(*)
  end
end


module Mumukit::Login
  def self.const_missing(name)
    if name == :User
      config.user_class.tap do |user_class|
        raise 'You must configure the Mumukit::Login.config.user_class first' unless user_class
        Mumukit::Login.const_set 'User', user_class
      end
    else
      super
    end
  end
end

module Mumukit::Login::SessionControllerHelpers

  def login
    origin_redirector.save_location!
    mumukit_controller.redirect! Mumukit::Login.auth_path
  end

  def callback
    user = Mumukit::Login::User.for_profile Mumukit::Login.normalized_omniauth_profile(env['omniauth.auth'])
    save_session_user_uid! user
    origin_redirector.redirect!
  end

  def destroy
    destroy_session_user_uid!
    mumukit_controller.redirect! Mumukit::Login.logout_redirection_path
  end
end

module Mumukit::Login::AuthenticationHelpers

  def authenticate!
    login_form.show! unless current_user?
  end

  def current_user?
    current_user_uid.present?
  end

  def current_user
    @current_user ||= Mumukit::Login::User.find_by_uid!(current_user_uid) if current_user?
  end

  def login_form
    @login_builder ||= Mumukit::Login.new_form mumukit_controller, login_settings
  end

  def origin_redirector
    @after_login_redirector ||= Mumukit::Login::OriginRedirector.new mumukit_controller
  end

end

Mumukit::Login.configure do |config|
  # User class must understand
  #     find_by_uid!
  #     for_profile
  config.user_class = User
end
