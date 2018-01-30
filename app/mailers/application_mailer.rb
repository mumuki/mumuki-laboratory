class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.reminder_sender_email
  layout 'mailer'
end

