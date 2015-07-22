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

    config.submission_notification_format = {except: :exercise_id,
                                             include: {
                                                 exercise: {only: [:id, :guide_id]},
                                                 submitter: {only: [:id, :name]}}}

    config.action_dispatch.rescue_responses.merge!(
        'AuthorizationError' => :unauthorized
    )

  end
end
