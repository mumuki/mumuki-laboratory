# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/we_miss_you_notification
  def we_miss_you_reminder
    UserMailer.we_miss_you_reminder(User.new, 1)
  end

  def custom_content_plain_text_notification
    notification = Notification.new user: user,
                                    organization: organization,
                                    subject: :custom,
                                    custom_content_plain_text: 'Welcome to Mumuki!',
                                    custom_title: 'Welcome!'

    UserMailer.notification notification
  end

  def custom_content_html_notification
    #TODO
  end

  def certificate
    certificate = Certificate.last

    UserMailer.certificate(certificate)
  end
end
