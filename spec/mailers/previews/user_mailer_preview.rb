# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/we_miss_you_notification
  def we_miss_you_reminder
    UserMailer.we_miss_you_reminder user, 1
  end

  def custom_content_plain_text_notification
    UserMailer.notification notification subject: :custom,
                                         custom_content_plain_text: 'This is the text of the mail. Awesome!',
                                         custom_title: 'This is the title!'
  end

  def custom_content_html_notification
    UserMailer.notification notification subject: :custom,
                                         custom_content_html: 'This is <em>the text</em> of the mail. <strong>Awesome!</strong>',
                                         custom_title: 'This is the title!'
  end

  def certificate_preview
    UserMailer.certificate certificate
  end

  def exam_registration_preview
    notification = notification target: exam_registration, subject: :exam_registration

    UserMailer.notification notification
  end

  def exam_authorization_request_approved
    notification = notification target: exam_authorization_request('approved'), subject: :exam_authorization_request_updated

    UserMailer.notification notification
  end

  def exam_authorization_request_rejected
    notification = notification target: exam_authorization_request('rejected'), subject: :exam_authorization_request_updated

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
    Notification.new({user: user,
                     organization: organization}.merge hash)
  end
end
