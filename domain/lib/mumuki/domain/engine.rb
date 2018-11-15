module Mumuki
  module Domain
    class Engine < ::Rails::Engine
      config.generators.api_only = true

      %w(exercise submission).each do |it|
        config.autoload_paths += %W(#{config.root}/app/models/#{it})
      end

      %w(submittable navigation).each do |it|
        config.autoload_paths += %W(#{config.root}/app/models/concerns/#{it})
      end
    end
  end
end
