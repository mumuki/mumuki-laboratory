# Load the Rails application.
require File.expand_path('../application', __FILE__)
Rails.application.initialize!

Mumukit::Auth.configure do |c|
  unless Rails.env.test?
    c.client_id = Rails.configuration.auth0_client_id
    c.client_secret = Rails.configuration.auth0_client_secret
  end
  c.persistence_strategy = PermissionsPersistence::Postgres.new
end

Mumukit::Nuntius.configure do |c|
  c.app_name = 'atheneum'
  c.notification_mode = Mumukit::Nuntius::NotificationMode.from_env
end
