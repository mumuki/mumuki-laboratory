module Mumuki
  module Laboratory
    class Engine < ::Rails::Engine
      config.generators.stylesheets = false
      config.generators.javascripts = false
      config.generators.test_framework = :rspec

      %w(evaluation exercise submission).each do |it|
        config.autoload_paths += %W(#{config.root}/app/models/#{it})
      end

      %w(submittable navigation).each do |it|
        config.autoload_paths += %W(#{config.root}/app/models/concerns/#{it})
      end

      config.assets.precompile += %w(user_shape.png)

      config.autoload_paths += %W(#{config.root}/plugins)
      config.autoload_paths += %W(#{config.root}/app/helpers/concerns)

      config.registration_notification_format = {only: [:id, :name, :email, :image_url]}
      config.action_dispatch.perform_deep_munge = false

      config.status_rendering_verbosity = :standard

      initializer "static assets" do |app|
          app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public")
      end

    end
  end
end
