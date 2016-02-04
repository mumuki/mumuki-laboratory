module Ace
  module Rails
    class Engine < ::Rails::Engine
      initializer 'ace-rails-ap.assets.precompile' do |app|
        app.config.assets.precompile -= %w[ace/worker-*.js]
        app.config.assets.precompile += %w[ace/worker-javascript.js]
      end
    end
  end
end

