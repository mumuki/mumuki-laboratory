require 'capybara/rails'
require 'capybara/rspec'

Capybara.app_host = 'http://test.mumuki.io'
Capybara.server_host = 'test.mumuki.op'
Capybara.server_port = '80'