Mumukit::Platform.configure do |config|
  config.application = Mumukit::Platform.laboratory
  config.web_framework = Mumukit::Platform::WebFramework::Rails
end

module Mumukit::Platform::OrganizationMapping::Path
  class << self
    alias_method :__organization_name__, :organization_name

    def organization_name(request, domain)
      name = __organization_name__(request, domain)
      if %w(auth login logout).include? name
        'central'
      else
        name
      end
    end
  end
end

module Mumukit::Platform::Serializable
  def dump(obj)
    obj.to_json
  end

  def load(json)
    new JSON.parse(json)
  end
end

class Mumukit::Platform::Model
  extend Mumukit::Platform::Serializable
  include ActiveModel::Model

  def self.model_attr_accessor(*keys)
    attr_accessor *keys
    define_singleton_method :parse do |json|
      new json.slice(*keys)
    end
  end
end

class Mumukit::Platform::Settings < Mumukit::Platform::Model
  model_attr_accessor :login_methods,
                      :raise_hand_enabled,
                      :public

  def raise_hand_enabled?
    !!raise_hand_enabled
  end

  def public?
    !!public
  end

  def private?
    !public?
  end

  def login_methods
    @login_methods ||= ['user_pass']
  end
end

class Mumukit::Platform::Settings < Mumukit::Platform::Model
  def login_settings
    @login_settings ||= Mumukit::Login::Settings.new(login_methods)
  end

  def customized_login_methods?
    login_methods.size < Mumukit::Login::Settings.login_methods.size
  end

  def inconsistent_public_login?
    customized_login_methods? && public?
  end
end

class Mumukit::Platform::Community < Mumukit::Platform::Model
  LOCALES = {
    en: { facebook_code: :en_US, name: 'English' },
    es: { facebook_code: :es_LA, name: 'Español' }
  }.with_indifferent_access

  model_attr_accessor :locale,
                      :description,
                      :contact_email,
                      :terms_of_service,
                      :community_link

  def locale_json
    LOCALES[locale].to_json
  end
end

class Mumukit::Platform::Theme < Mumukit::Platform::Model
  model_attr_accessor :logo_url,
                      :theme_stylesheet_url,
                      :extension_javascript_url
end

module Mumukit::Platform::OrganizationHelpers
  extend ActiveSupport::Concern

  included do
    delegate :logo_url,
             :theme_stylesheet_url,
             :extension_javascript_url, to: :theme

    delegate :login_methods,
             :login_methods=,
             :login_settings,
             :raise_hand_enabled?,
             :raise_hand_enabled=,
             :customized_login_methods?,
             :public?,
             :public=,
             :private?, to: :settings

    delegate :locale,
             :locale_json,
             :description,
             :description=,
             :community_link,
             :terms_of_service,
             :terms_of_service=,
             :contact_email,
             :contact_email=, to: :community

  end

  def slug
    Mumukit::Auth::Slug.join_s name
  end

  def central?
    name == 'central'
  end

  def test?
    name == 'test'
  end

  def switch!
    Mumukit::Platform::Organization.switch! self
  end

  def to_s
    name
  end

  def url_for(path)
    Mumukit::Platform.application.organic_url_for(name, path)
  end

  def domain
    Mumukit::Platform.application.organic_domain(name)
  end

  module ClassMethods
    def current
      Mumukit::Platform::Organization.current
    end
  end
end
