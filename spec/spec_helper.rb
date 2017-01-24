ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'rspec/rails'
require 'rspec/autorun'
require 'codeclimate-test-reporter'
require 'mumukit/core/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|

  config.use_transactional_fixtures = true

  config.infer_base_class_for_anonymous_controllers = false

  config.order = '1'

  config.include FactoryGirl::Syntax::Methods

  config.infer_spec_type_from_file_location!

end

require_relative './capybara_helper'
require_relative './evaluation_helper'

RSpec.configure do |config|
  config.before(:each) do
    unless RSpec.current_example.metadata[:clean]
      create(:public_organization,
             name: 'test',
             book: create(:book, name: 'test', slug: 'mumuki/mumuki-the-book')).switch!
    end
  end

  config.after(:each) do
    Organization.current = nil
    set_subdomain_host! 'test'
    FileUtils.rm ["#{Mumukit::Auth.config.daybreak_name}.db"], force: true
  end
end

def reindex_organization!(organization)
  organization.reload
  organization.reindex_usages!
end

def reindex_current_organization!
  reindex_organization! Organization.current
end

def set_subdomain_host!(subdomain)
  Capybara.app_host = "http://#{subdomain}.mumuki.io"
end

def set_implicit_central!
  Capybara.app_host = "http://mumuki.io"

end

def set_current_user!(user)
  allow_any_instance_of(ApplicationController).to receive(:current_user_uid).and_return(user.uid)
end

Mumukit::Login.configure do |config|
  config.auth0 = struct
  config.saml = struct
end

SimpleCov.start
