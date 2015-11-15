require File.expand_path('../boot', __FILE__)

require 'rails/all'
require_relative '../config/initializers/verobosity'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mumuki
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.generators.stylesheets = false
    config.generators.javascripts = false
    config.generators.test_framework = :rspec

    config.autoload_paths += %W(#{config.root}/plugins)
    config.autoload_paths += %W(#{config.root}/app/helpers/concerns)
    config.autoload_paths += %W(#{config.root}/app/models/exercise)
    config.autoload_paths += %W(#{config.root}/app/models/submission)
    config.autoload_paths += %W(#{config.root}/app/models/concerns/submittable)

    config.registration_notification_format = {only: [:id, :name, :email, :image_url]}

    config.action_dispatch.rescue_responses.merge!(
        'AuthorizationError' => :unauthorized
    )
  end
end
