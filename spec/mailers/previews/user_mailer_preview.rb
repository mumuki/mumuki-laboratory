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

  def welcome_preview
    UserMailer.welcome_email user, organization
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
    Organization.new Organization.central.as_json.merge welcome_email_sender: 'test@mumuki.org',
                                                        welcome_email_template: template
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

  def template
    <<~HTML
      <p>Queremos compartirte unos consejos para que puedas aprovechar la plataforma al máximo:</p>

      <ul style="padding-left: 24px;">
        <li>Para conocer todas las funcionalidades de la plataforma, leé atentamente el <a href="https://www.argentina.gob.ar/sites/default/files/ap_manual_de_uso_plataforma_mumuki_para_estudiantes.pdf" target="_blank" style="color: #17687D;">Manual de Uso</a>.</li>
        <li>Si tenés dudas sobre el curso o el examen, revisá la sección de <a href="https://mumuki.io/argentina-programa/faqs" target="_blank" style="color: #17687D;">Información Importante</a>.</li>
        <li>Para reforzar y ampliar los conocimientos de cada capítulo, consultá los apéndices, que se encuentran debajo del listado de lecciones.</li>
      </ul>

      <hr style="margin: 32px 0; margin-right: 75%; border: 1px solid rgba(0, 0, 0, 0.24);">

      <h2 style="font-size: 24px; font-weight: normal; line-height: 32px; margin-bottom: 32px;">
        Seguí aprendiendo con estas lecturas
      </h2>

      <div style="padding: 0 32px; font-size: 18px; width: 100%; display: inline-flex;">
        <div style="width: 50%; max-width: 205px; color: unset; text-decoration: none; margin-right: 32px;">
          <img src="https://miro.medium.com/max/1400/1*GFbm2AwdDhOuqczuwvFpUA.png" alt="" style="object-fit: cover; height: 205px; width: 100%;">
          <p>15 palabras sobre programación que deberías conocer</p>
          <div style="height: 40px;">
            <a target="_blank" href="https://medium.com/proyecto-mumuki/15-palabras-sobre-programaci%C3%B3n-que-deber%C3%ADas-conocer-7055158bb258" style="height: 100%; padding: 8px 16px 10px; background: #17687D; border-radius: 20px; color: white; text-decoration: none;">Leer ahora</a>
          </div>
        </div>
        <div style="width: 50%; max-width: 205px; color: unset; text-decoration: none;">
          <img src="https://miro.medium.com/max/1400/1*y7Fcbu90Efnv64C-VpmtIQ.png" alt="" style="object-fit: cover; height: 205px; width: 100%;">
          <p>Errores comunes que cometemos cuando aprendemos a programar</p>
          <div style="height: 40px;">
            <a target="_blank" href="https://medium.com/proyecto-mumuki/errores-comunes-que-cometemos-cuando-aprendemos-a-programar-b42b9c982acc" style="height: 100%; padding: 8px 16px 10px; background: #17687D; border-radius: 20px; color: white; text-decoration: none;">Leer ahora</a>
          </div>
        </div>
      </div>
    HTML
  end
end
