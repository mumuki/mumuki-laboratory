source 'https://rubygems.org'
gemspec

ruby '~> 2.3'

gem 'puma'

gem 'execjs'
gem 'therubyracer', platforms: :ruby
gem 'uglifier', '~> 2.7'

group :test do
  gem 'rspec-rails', '~> 3.6'
  gem 'factory_bot_rails'
  gem 'faker', '~> 1.5'
  gem 'rake', '~> 12.3'
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
  gem 'web-console', '~> 3.7.0'
  gem 'codeclimate-test-reporter', require: nil
end

gem 'mumuki-domain', github:  'mumuki/mumuki-domain', ref: 'a4ce311bb49a9227bbf7f06ef6e0fddd908f4393'
