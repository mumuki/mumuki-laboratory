class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def welcome_email(user)
  	@user = user
  	@url = 'http://mumuki.io'
  	mail(to: @user.email, subject: 'Welcome to Mumuki!')
  end

  def motivation_email(user)
  	@user = user
  	@url = 'http://mumuki.io/es/exercises'
  	mail(to: @user.email, subject: 'Hey! Come and practice with us!')
  end

end
