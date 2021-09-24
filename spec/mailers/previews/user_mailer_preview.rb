# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/we_miss_you_reminder
  def we_miss_you_reminder
    UserMailer.we_miss_you_reminder user, 1
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/certificate_preview
  def certificate_preview
    UserMailer.certificate certificate
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/exam_registration_preview
  def exam_registration_preview
    notification = notification target: exam_registration

    UserMailer.notification notification
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/exam_authorization_request_approved
  def exam_authorization_request_approved
    notification = notification target: exam_authorization_request('approved')

    UserMailer.notification notification
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/exam_authorization_request_rejected
  def exam_authorization_request_rejected
    notification = notification target: exam_authorization_request('rejected')

    UserMailer.notification notification
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/custom_content_plain_text_notification
  def custom_content_plain_text_notification
    notification = notification target: custom_notification

    UserMailer.notification notification target: custom_notification
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/custom_content_html_notification
  def custom_content_html_notification
    notification = notification target: custom_notification('This is <em>the text</em> of the mail. <strong>Awesome!</strong>')

    UserMailer.notification notification
  end

  def delete_account
    UserMailer.delete_account user
  end

  private

  def exam_registration
    ExamRegistration.new id: 1,
                         organization: organization,
                         description: 'Some test description',
                         start_time: 5.minute.ago,
                         end_time: 5.minutes.since

  end

  def exam_authorization_request(status)
    ExamAuthorizationRequest.new id: 1,
                                 user: user,
                                 status: status,
                                 exam: exam,
                                 organization: organization
  end

  def custom_notification(custom_html = '')
    CustomNotification.new id: 1,
                           organization: organization,
                           title: 'This is the title!',
                           body_html: 'This is the text of the mail. <strong>Awesome!</strong>',
                           custom_html: custom_html
  end

  def exam
    Exam.new organization: organization,
             start_time: 5.minute.ago,
             end_time: 5.minutes.since
  end

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
    Notification.new({user: user, organization: organization}.merge hash)
  end
end
