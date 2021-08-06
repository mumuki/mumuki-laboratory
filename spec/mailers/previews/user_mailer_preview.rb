# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/we_miss_you_notification
  def we_miss_you_reminder
    UserMailer.we_miss_you_reminder user, 1
  end

  def custom_content_plain_text_notification
    UserMailer.notification notification
  end

  def custom_content_html_notification
    UserMailer.notification notification(custom_content_html: 'This is <em>the text</em> of the mail. <strong>Awesome!</strong>')
  end

  def certificate_preview
    UserMailer.certificate certificate
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

  def certificate
    certificate_program = CertificateProgram.find_or_create_by!(title: 'Mumuki Certificate',
                                                                description: 'Functional Programming',
                                                                organization: organization,
                                                                start_date: 1.minute.ago,
                                                                end_date: 1.hour.since)

    Certificate.new user: user, certificate_program:  certificate_program
  end

  def notification(**hash)
    Notification.new({user: user,
                     organization: organization,
                     subject: :custom,
                     custom_content_plain_text: 'This is the text of the mail. Awesome!',
                     custom_title: 'This is the title!'}.merge hash)
  end
end
