source 'https://rubygems.org'
gemspec

ruby '~> 2.3'

gem 'uglifier', '~> 2.7'

gem 'therubyracer', platforms: :ruby

gem 'turbolinks', '~> 5.0'

gem 'sass-rails'
gem 'execjs'

source 'https://rails-assets.org' do
  gem 'rails-assets-momentjs'
end

gem 'puma'

gem 'rails-i18n', '~> 4.0.0'

gem 'nprogress-rails'
gem 'mumuki-styles', '~> 1.16'

gem 'mumukit-platform', github: 'mumuki/mumukit-platform', branch: 'feature-unified-platform-model'
gem 'mumukit-login', github: 'mumuki/mumukit-login', branch: 'feature-unified-platform-model'

gem 'font-awesome-rails', '~> 4.7'

group :test do
  gem 'rspec-rails', '~> 3.6'
  gem 'factory_bot_rails'
  gem 'rake', '10.4.2'
  gem 'faker', '~> 1.5'
  gem 'capybara', '~> 2.3.0'
end

group :development do
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-byebug' unless Gem.win_platform?
  gem 'pry-stack_explorer'
  gem 'binding_of_caller'
  gem 'i18n-tasks', '~> 0.8.3'
  gem 'web-console'
end

gem 'codeclimate-test-reporter', :group => :test, :require => nil

gem 'sitemap_generator'
