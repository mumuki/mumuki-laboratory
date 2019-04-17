source 'https://rubygems.org'
gemspec

ruby '~> 2.3'

gem 'puma'

source 'https://rails-assets.org' do
  gem 'rails-assets-momentjs'
end
gem 'uglifier', '~> 2.7'
gem 'therubyracer', platforms: :ruby
gem 'turbolinks', '~> 5.0'
gem 'sass-rails'
gem 'execjs'
gem 'rails-i18n', '~> 4.0.0'
gem 'nprogress-rails'
gem 'sitemap_generator'
gem 'font-awesome-rails', '~> 4.7'
gem 'image_processing', '~> 1.2'

group :test do
  gem 'rspec-rails', '~> 3.6'
  gem 'factory_bot_rails'
  gem 'faker', '~> 1.5'
  gem 'rake', '10.4.2'
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
  gem 'codeclimate-test-reporter', require: nil
end

gem 'mumuki-domain', git: "https://github.com/mumuki/mumuki-domain.git", ref: "16fd2fec450a9d62fec1335f7e5f59a71ed2735e"
