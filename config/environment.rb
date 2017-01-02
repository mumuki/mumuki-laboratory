# Load the Rails application.
require File.expand_path('../application', __FILE__)
Rails.application.initialize!

Mumukit::Auth.configure do |c|
  c.client_id = Rails.configuration.auth0_client_id
  c.client_secret = Rails.configuration.auth0_client_secret
  c.daybreak_name = Rails.configuration.daybreak_name
  c.persistence_strategy = PermissionsPersistence::Postgres.new c.daybreak_name
end

Mumukit::Nuntius.configure do |c|
  c.app_name = 'atheneum'
  c.notification_mode = Rails.env.test?? Mumukit::Nuntius::NotificationMode::Deaf.new : Mumukit::Nuntius::NotificationMode.from_env
end
