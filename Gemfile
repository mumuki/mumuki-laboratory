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

gem 'mumuki-domain', github: 'mumuki/mumuki-domain', ref: 'c13e77d7c132fd21b0a06d7dfd8a115491ce6fec'
