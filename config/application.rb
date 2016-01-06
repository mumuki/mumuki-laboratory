require File.expand_path('../boot', __FILE__)

require 'rails/all'
require_relative '../config/initializers/verobosity'

Bundler.require(*Rails.groups)

module Mumuki
  class Application < Rails::Application
    config.generators.stylesheets = false
    config.generators.javascripts = false
    config.generators.test_framework = :rspec

    config.autoload_paths += %W(#{config.root}/plugins)
    config.autoload_paths += %W(#{config.root}/app/helpers/concerns)
    config.autoload_paths += %W(#{config.root}/app/models/exercise)
    config.autoload_paths += %W(#{config.root}/app/models/submission)
    config.autoload_paths += %W(#{config.root}/app/models/concerns/submittable)

    config.registration_notification_format = {only: [:id, :name, :email, :image_url]}
    config.action_dispatch.perform_deep_munge = false
  end
end
