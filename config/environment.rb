# Load the Rails application.
require File.expand_path('../application', __FILE__)
Rails.application.initialize!
if !Rails.env.test? && Rails.configuration.saml_idp_cert.present?
  File.open('../saml.crt', 'w') { |file| file.write(Rails.configuration.saml_idp_cert.gsub("\\n", "\n")) }
end

Mumukit::Auth.configure do |c|
  unless Rails.env.test?
    c.client_id = Rails.configuration.auth0_client_id
    c.client_secret = Rails.configuration.auth0_client_secret
  end
  c.persistence_strategy = PermissionsPersistence::Postgres.new
end

Mumukit::Nuntius.configure do |c|
  c.app_name = 'atheneum'
  c.notification_mode = Rails.env.test? ? Mumukit::Nuntius::NotificationMode::Deaf.new : Mumukit::Nuntius::NotificationMode.from_env
end
