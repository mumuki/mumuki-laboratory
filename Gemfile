source 'https://rubygems.org'
ruby '~> 2.3'

gem 'rails', '~> 5.1.3'

gem 'pg', '~> 0.18.0'

gem 'uglifier', '~> 2.7'

gem 'therubyracer', platforms: :ruby

gem 'turbolinks', '~> 5.0'

gem 'sass-rails'
gem 'execjs'

gem 'jquery-rails'

source 'https://rails-assets.org' do
  gem 'rails-assets-dev-awesome', '0.4.1'
  gem 'rails-assets-awesome-bootstrap-checkbox'
  gem 'rails-assets-momentjs'
  gem 'rails-assets-mumuki-styles', '1.8.0'
end


gem 'puma'

gem 'bootstrap_form'

gem 'rails-i18n', '~> 4.0.0'

gem 'font-awesome-rails', '~> 4.7'
gem 'nprogress-rails'

gem 'mumukit-content-type',
    git: 'https://github.com/mumuki/mumukit-content-type',
    require: 'mumukit/content_type',
    ref: 'v1.0.0-mumuki-rouge'
gem 'rouge',
    git: 'https://github.com/mumuki/rouge',
    ref: '5a8db3387f3a67232569969cd3da40ee04eb9dc3'

gem 'mumukit-auth', '~> 7.1'
gem 'mumukit-core', '~> 1.1'
gem 'mumukit-bridge', '~> 3.2'
gem 'mumukit-inspection', '~> 3.1'
gem 'mumukit-nuntius', '~> 5.0'
gem 'mumukit-platform', '~> 0.5'
gem 'mumukit-login', '~> 4.0'

gem 'rack', '~> 2.0'
gem 'omniauth', '~> 1.4.0'

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
