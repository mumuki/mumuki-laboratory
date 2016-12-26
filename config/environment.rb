# Load the Rails application.
require File.expand_path('../application', __FILE__)
Rails.application.initialize!

Mumukit::Auth.configure do |c|
  c.client_id = Rails.configuration.auth_client_id
  c.client_secret = Rails.configuration.auth_client_secret
  c.daybreak_name = Rails.configuration.daybreak_name
end

Mumukit::Nuntius.configure do |c|
  c.app_name = 'atheneum'
end
