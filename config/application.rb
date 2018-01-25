require File.expand_path('../boot', __FILE__)

require 'rails/all'
require_relative '../lib/mumuki/laboratory'

Bundler.require(*Rails.groups)

module Mumuki
  class Application < Rails::Application
    config.load_defaults 5.1

    config.generators.stylesheets = false
    config.generators.javascripts = false
    config.generators.test_framework = :rspec

    config.autoload_paths += %W(#{config.root}/plugins)

    config.autoload_paths += %W(#{config.root}/app/helpers/concerns)

    %w(status evaluation exercise submission).each do |it|
      config.autoload_paths += %W(#{config.root}/app/models/#{it})
    end

    %w(submittable navigation).each do |it|
      config.autoload_paths += %W(#{config.root}/app/models/concerns/#{it})
    end

    config.registration_notification_format = {only: [:id, :name, :email, :image_url]}
    config.action_dispatch.perform_deep_munge = false

    config.sender_email = ENV['SENDER_EMAIL']
    config.smtp_address = ENV['SMTP_ADDRESS']
    config.mailer_username = ENV['MAILER_USERNAME']
    config.mailer_password = ENV['MAILER_PASSWORD']
    config.reminder_frequency = ENV['REMINDER_FREQUENCY'].defaulting(7, &:to_i)
  end
end
