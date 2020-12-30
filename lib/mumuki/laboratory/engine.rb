require 'turbolinks'
require 'font_awesome5_rails'
require 'momentjs-rails'
require 'nprogress-rails'
require 'rails-i18n'
require 'sassc-rails'

module Mumuki
  module Laboratory
    class Engine < ::Rails::Engine
      require 'mumuki/styles'
      require 'muvment'

      config.generators.stylesheets = false
      config.generators.javascripts = false
      config.generators.test_framework = :rspec

      config.assets.precompile += %w(user_shape.png)

      config.autoload_paths += %W(#{config.root}/plugins)
      config.autoload_paths += %W(#{config.root}/app/helpers/concerns)

      config.registration_notification_format = {only: [:id, :name, :email, :image_url]}
      config.action_dispatch.perform_deep_munge = false

      initializer "static assets" do |app|
          app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public")
      end

    end
  end
end
