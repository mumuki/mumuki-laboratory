# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/we_miss_you_notification
  def we_miss_you_reminder
    UserMailer.we_miss_you_reminder user, 1
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
    UserMailer.certificate new_certificate
  end

  private

  def user
    User.new uid: 'some_user@gmail.com',
             first_name: 'Some',
             last_name: 'User',
             verified_first_name: 'Jane',
             verified_last_name: 'Doe',
             last_organization: organization
  end

  def organization
    Organization.central
  end

  def new_certificate
    certificate_program = CertificateProgram.find_or_create_by!(title: 'Mumuki Certificate',
                                                                description: 'Functional Programming',
                                                                organization: organization,
                                                                start_date: 1.minute.ago,
                                                                end_date: 1.hour.since)

    Certificate.new user: user, certificate_program:  certificate_program
  end
end
