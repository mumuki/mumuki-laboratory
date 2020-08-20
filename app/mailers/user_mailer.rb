class UserMailer < ApplicationMailer
  def welcome_email(user, organization)
    organization_name = organization[:display_name] || t(:your_new_organization)
    build_email user, t(:welcome, name: organization_name), { inline: organization.welcome_email_template }, organization
  end

  def we_miss_you_reminder(user, cycles)
    build_email user, t(:we_miss_you), "#{cycles.ordinalize}_reminder"
  end

  def no_submissions_reminder(user)
    build_email user, t(:start_using_mumuki), 'no_submissions_reminder'
  end

  private

  def build_email(user, subject, template, organization = nil)
    @user = user
    @unsubscribe_code = User.unsubscription_verifier.generate(user.id)
    @organization = organization || user.last_organization

    I18n.with_locale(@organization.locale) do
      mail to: user.email,
           subject: subject,
           content_type: 'text/html',
           body: render(template)
    end
  end
end
