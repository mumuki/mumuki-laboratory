source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '~> 4.1.14'

gem 'pg', '~> 0.18.0'
gem 'pg_search', '~> 1.0'

gem 'uglifier', '~> 2.7'

gem 'therubyracer', :platforms => :ruby

gem 'turbolinks'

gem 'sass-rails'
gem 'execjs'

gem 'jquery-rails'

source 'https://rails-assets.org' do
  gem 'rails-assets-devicons'
end

gem 'bootstrap-sass', '~> 3.3.5'
gem 'bootswatch-rails'

gem 'omniauth', '~> 1.2'
gem 'omniauth-auth0', '~> 1.1'

gem 'font-awesome-rails'

gem 'ace-rails-ap', '~> 4.0'

gem 'puma'

gem 'kaminari', '~> 0.16.3'
gem 'bootstrap-kaminari-views'

gem 'bootstrap_form'

gem 'i18n-tasks', '~> 0.8.3'
gem 'rails-i18n', '~> 4.0.0'

gem 'nprogress-rails'

gem 'yaml_db'

gem 'bunny'

gem 'addressable'

gem 'mumukit-inspection', github: 'mumuki/mumukit-inspection', :branch => 'master'
gem 'mumukit-content-type', github: 'mumuki/mumukit-content-type', :branch => 'master', require: 'mumukit/content_type'
gem 'mumukit-bridge', github: 'mumuki/mumukit-bridge', :tag => 'v1.1.0'
gem 'mumukit-nuntius', github: 'mumuki/mumukit-nuntius', :tag => 'v0.2.2'
gem 'mumukit-auth', github: 'mumuki/mumukit-auth', :tag => 'v0.1.1'

group :test do
  gem 'rspec-rails', '~> 2.14'
  gem 'factory_girl_rails'
  gem 'rake', '10.4.2'
  gem 'faker', '~> 1.5'
  gem 'capybara', '~> 2.3.0'
end

group :development do
  gem 'better_errors'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-byebug' unless Gem.win_platform?
  gem 'pry-stack_explorer'
  gem 'binding_of_caller'
end

#Add integration of test coverage with Code Climate
gem 'codeclimate-test-reporter', :group => :test, :require => nil

gem 'sitemap_generator'


# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
