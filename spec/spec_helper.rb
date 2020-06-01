ENV['RAILS_ENV'] ||= 'test'
ENV['MUMUKI_ENABLED_LOGIN_PROVIDERS'] = 'developer'

require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'codeclimate-test-reporter'
require 'mumukit/core/rspec'
require 'factory_bot_rails'

require 'mumuki/domain/factories'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  config.use_transactional_fixtures = true

  config.infer_base_class_for_anonymous_controllers = false

  config.order = '1'

  config.include FactoryBot::Syntax::Methods

  config.infer_spec_type_from_file_location!

  config.full_backtrace = true if ENV['RSPEC_FULL_BACKTRACE']
end

require_relative './capybara_helper'
require_relative './api_helper'
require_relative './evaluation_helper'
require_relative './login_helper'

RSpec.configure do |config|
  config.before(:each) { set_automatic_login! true }

  config.before(:each) { I18n.locale = :en }

  config.before(:each) do
    if RSpec.current_example.metadata[:organization_workspace] == :test
      set_subdomain_host! 'test'
      create(:public_organization,
          name: 'test',
          book: create(:book, name: 'test', slug: 'mumuki/mumuki-the-book')).switch!
    elsif RSpec.current_example.metadata[:organization_workspace] == :base
      set_subdomain_host! 'base'
      create(:organization, name: 'base',
                            logo_url: 'http://mumuki.io/logo-alt-large.png',
                            terms_of_service: 'Default terms of service',
                            theme_stylesheet: '.defaultCssFromBase { css: red }',
                            extension_javascript: 'function jsFromBase() {}').switch!
    end
  end

  config.after(:each) do
    Mumukit::Platform::Organization.leave! if RSpec.current_example.metadata[:organization_workspace]
  end
end


Mumukit::Auth.configure do |c|
  c.clients.default = {id: 'test-client', secret: 'thisIsATestSecret'}
end

def reindex_organization!(organization)
  organization.reload
  organization.reindex_usages!
end

def reindex_current_organization!
  reindex_organization! Organization.current
end

User.configure_buried_profile! first_name: 'shibi', last_name: '', email: 'shibi@mumuki.org'

SimpleCov.start
