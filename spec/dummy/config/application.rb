require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "mumuki/laboratory"

module Dummy
  class Application < Rails::Application
    config.load_defaults 5.1

    Mumuki::Domain::Engine.paths['db/migrate'].expanded.each do |expanded_path|
      config.paths['db/migrate'] << expanded_path
    end
  end
end

