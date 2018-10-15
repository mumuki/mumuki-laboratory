$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mumuki/laboratory/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mumuki-laboratory"
  s.version     = Mumuki::Laboratory::VERSION
  s.authors     = ["Franco Bulgarelli"]
  s.email       = ["franco@mumuki.org"]
  s.homepage    = "https://mumuki.io"
  s.summary     = "Code assement web application for the Mumuki Platform."
  s.description = "Where students practice and receive automated and human feedback."
  s.license     = "GPL-3.0"

  s.files = Dir["{app,config,db,lib,public,vendor}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 5.1.3"

  s.add_dependency 'mumukit-content-type', '~> 1.4'
  s.add_dependency 'mumukit-auth', '~> 7.4'
  s.add_dependency 'mumukit-core', '~> 1.3'
  s.add_dependency 'mumukit-bridge', '~> 3.7'
  s.add_dependency 'mumukit-inspection', '~> 3.5'
  s.add_dependency 'mumukit-nuntius', '~> 6.1'
  s.add_dependency 'mumukit-platform', '~> 2.7'
  s.add_dependency 'mumukit-login', '~> 6.1'
  s.add_dependency 'mumukit-directives', '~> 0.5'
  s.add_dependency 'mumukit-assistant', '~> 0.1'
  s.add_dependency 'mumukit-randomizer', '~> 1.0'

  s.add_dependency 'mumuki-domain', Mumuki::Laboratory::VERSION

  s.add_dependency 'rack', '~> 2.0'
  s.add_dependency 'omniauth', '~> 1.4.0'

  s.add_dependency 'kaminari', '~> 0.16'
  s.add_dependency 'bootstrap-kaminari-views'

  s.add_development_dependency 'pg', '~> 0.18.0'
end
