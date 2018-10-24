class UserMailer < ApplicationMailer

  def we_miss_you_reminder(user, cycles)
    send_reminder! user, :we_miss_you, "#{cycles.ordinalize}_reminder"
  end

  def no_submissions_reminder(user)
    send_reminder! user, :start_using_mumuki, "no_submissions_reminder"
  end

  private

  def send_reminder!(user, subject, template_name)
    @user = user
    @unsubscribe_code = User.unsubscription_verifier.generate(user.id)
    @organization = user.last_organization

    I18n.with_locale(@organization.locale) do
      mail to: user.email,
           subject: t(subject),
           template_name: template_name
    end
  end
end
