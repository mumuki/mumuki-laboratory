$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mumuki/domain/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mumuki-domain"
  s.version     = Mumuki::Domain::VERSION
  s.authors     = ["Franco Leonardo Bulgarelli"]
  s.email       = ["franco@mumuki.org"]
  s.homepage    = "https://mumuki.org"
  s.summary     = "Mumuki's Domain Model"
  s.description = "Mumuki's Domain Model"
  s.license     = "GPL-3.0"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.6"

  s.add_dependency 'mumukit-auth', '~> 7.5'
  s.add_dependency 'mumukit-assistant', '~> 0.1'
  s.add_dependency 'mumukit-bridge', '~> 3.7'
  s.add_dependency 'mumukit-content-type', '~> 1.4'
  s.add_dependency 'mumukit-core', '~> 1.6'
  s.add_dependency 'mumukit-directives', '~> 0.5'
  s.add_dependency 'mumukit-inspection', '~> 3.5'
  s.add_dependency 'mumukit-randomizer', '~> 1.0'
end
