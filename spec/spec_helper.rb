ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'codeclimate-test-reporter'
require 'mumukit/core/rspec'
require 'factory_bot_rails'

Dir["#{__dir__}/factories/**/*.rb"].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  config.use_transactional_fixtures = true

  config.infer_base_class_for_anonymous_controllers = false

  config.order = '1'

  config.include FactoryBot::Syntax::Methods

  config.infer_spec_type_from_file_location!

end

require_relative './capybara_helper'
require_relative './evaluation_helper'

RSpec.configure do |config|
  config.before(:each) do
    if RSpec.current_example.metadata[:organization_workspace] == :test
      set_subdomain_host! 'test'
      create(:public_organization,
          name: 'test',
          book: create(:book, name: 'test', slug: 'mumuki/mumuki-the-book')).switch!
    elsif RSpec.current_example.metadata[:organization_workspace] == :base
      set_subdomain_host! 'test'
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

def set_api_client!
  @request.env["HTTP_AUTHORIZATION"] = api_client.token
end

def reindex_organization!(organization)
  organization.reload
  organization.reindex_usages!
end

def reindex_current_organization!
  reindex_organization! Organization.current
end

def set_current_user!(user)
  allow_any_instance_of(ApplicationController).to receive(:current_user_uid).and_return(user.uid)
end

Mumukit::Login.configure do |config|
  config.auth0 = struct
  config.saml = struct

  config.mucookie_domain = '.localmumuki.io'
  config.mucookie_secret_key = 'abcde1213456123456'
  config.mucookie_secret_salt = 'mucookie test secret salt'
  config.mucookie_sign_salt = 'mucookie test sign salt'
end


class String
  def parse_json
    JSON.parse(self, symbolize_names: true)
  end
end

OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:developer] =
  OmniAuth::AuthHash.new provider: 'developer',
                         uid: 'johndoe@test.com',
                         credentials: {},
                         info: {first_name: 'John', last_name: 'Doe', name: 'John Doe', nickname: 'johndoe'}


SimpleCov.start
