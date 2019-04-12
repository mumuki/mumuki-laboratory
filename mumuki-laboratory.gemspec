$:.push File.expand_path("../lib", __FILE__)

require "mumuki/laboratory/version"

Gem::Specification.new do |s|
  s.name        = "mumuki-laboratory"
  s.version     = Mumuki::Laboratory::VERSION
  s.authors     = ["Franco Bulgarelli"]
  s.email       = ["franco@mumuki.org"]
  s.homepage    = "https://mumuki.io"
  s.summary     = "Code assement web application for the Mumuki Platform."
  s.description = "Where students practice and receive automated and human feedback."
  s.license     = "AGPL-3.0"

  s.files = Dir["{app,config,db,lib,public,vendor}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 5.1.6"

  s.add_dependency 'mumuki-domain', '~> 6.6.1'
  s.add_dependency 'mumukit-login', '~> 6.1'
  s.add_dependency 'mumukit-nuntius', '~> 6.1'

  s.add_dependency 'mumuki-styles', '~> 1.19'
  s.add_dependency 'muvment', '~> 1.2'

  s.add_dependency 'rack', '~> 2.0'
  s.add_dependency 'omniauth', '~> 1.4.0'

  s.add_dependency 'kaminari', '~> 0.16'
  s.add_dependency 'bootstrap-kaminari-views'

  s.add_development_dependency 'pg', '~> 0.18.0'
end
