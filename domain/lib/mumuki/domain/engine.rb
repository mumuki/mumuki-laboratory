module Mumuki
  module Domain
    class Engine < ::Rails::Engine
      config.generators.api_only = true
    end
  end
end
