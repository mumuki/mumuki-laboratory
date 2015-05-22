class UserMailer < ActionMailer::Base
  default from: "donotreply@mumuki.io"

  def motivation_email(user)
  	@user = user
  	@url_exercises = 'http://mumuki.io'
  	self.mail(to: user.email, subject: 'Hey! Come and practice with us!')
  end

end
