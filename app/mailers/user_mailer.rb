class UserMailer < ApplicationMailer

  def we_miss_you_reminder(user, cycles)
    @user = user
    @unsubscribe_code = User.unsubscription_verifier.generate(user.id)

    I18n.with_locale(user.last_organization.locale) do
      mail to: user.email,
           subject: t(:we_miss_you),
           template_name: "#{cycles.ordinalize}_reminder"
    end
  end

end
