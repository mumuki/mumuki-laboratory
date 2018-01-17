# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/we_miss_you_notification
  def we_miss_you_notification
    UserMailer.we_miss_you_notification(User.first)
  end

end
