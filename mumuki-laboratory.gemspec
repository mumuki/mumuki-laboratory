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

  s.add_dependency 'mumuki-domain', '~> 9.23.0'
  s.add_dependency 'mumukit-bridge', '~> 4.1'
  s.add_dependency 'mumukit-login', '~> 7.7'
  s.add_dependency 'mumukit-nuntius', '~> 6.1'
  s.add_dependency 'mumukit-auth', '~> 7.11'
  s.add_dependency 'mumukit-content-type', '~> 1.9'

  s.add_dependency 'mumuki-styles', '~> 3.0'
  s.add_dependency 'muvment', '~> 1.2'

  s.add_dependency 'rack', '~> 2.1'
  s.add_dependency 'omniauth', '~> 1.4'

  s.add_dependency 'kaminari', '~> 0.16'
  s.add_dependency 'bootstrap5-kaminari-views', '~> 0.0.1'

  s.add_dependency 'font_awesome5_rails', '~> 1.3'
  s.add_dependency 'momentjs-rails', '~> 2.10'
  s.add_dependency 'nprogress-rails', '~> 0.2'
  s.add_dependency 'rails-i18n', '~> 4.0.0'
  s.add_dependency 'sassc-rails', '~> 2.1'
  s.add_dependency 'turbolinks', '~> 5.0'
  s.add_dependency 'sprockets', '~> 3.7'
  s.add_dependency 'mini_racer', '>= 0.4', '< 0.5'

  s.add_dependency 'wkhtmltopdf-binary', '~> 0.12'
  s.add_dependency 'wicked_pdf', '~> 1.4'
  s.add_dependency 'rqrcode', '~> 1.2'

  s.add_development_dependency 'pg', '~> 0.18.0'
  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'webdrivers', '~> 4.4'
end
