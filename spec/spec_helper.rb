# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'
require 'rspec/rails'
require 'rspec/autorun'
require "codeclimate-test-reporter"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|

  config.use_transactional_fixtures = true

  config.infer_base_class_for_anonymous_controllers = false

  config.order = "1"

  config.include FactoryGirl::Syntax::Methods

  config.infer_spec_type_from_file_location!

end

require_relative './apartment_helper'
require_relative './capybara_helper'
require_relative './evaluation_helper'

CodeClimate::TestReporter.start


RSpec::Matchers.define :json_eq do |expected_json_hash|
  match do |actual_json|
    expected_json_hash.with_indifferent_access == ActiveSupport::JSON.decode(actual_json)
  end
end
