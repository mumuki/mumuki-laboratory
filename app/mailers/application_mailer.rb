class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.reminder_sender_email
  layout 'mailer'

  def self.mailer_environment_variables
    %w( MUMUKI_REMINDER_SENDER_EMAIL
        MUMUKI_REMINDER_MAILER_SMTP_ADDRESS
        MUMUKI_REMINDER_MAILER_USERNAME
        MUMUKI_REMINDER_MAILER_PASSWORD)
  end

  def self.environment_variables_set?
    mailer_environment_variables.all? { |env_var| ENV[env_var].present? }
  end
end
