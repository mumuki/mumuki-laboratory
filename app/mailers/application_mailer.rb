class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.sender_email
  layout 'mailer'
end

