namespace :users do

  def send_we_miss_you(user, weeks)
    UserMailer.new.we_miss_you_notification(user, weeks).deliver
  end

  def days_since(a_time)
    (Date.current - a_time.to_date).to_i
  end

  def send_we_miss_you_reminder(user)
    days = days_since user.last_submission_date
    send_we_miss_you user, days / 7 if days.multiple_of?(7)
  end

  task notify_reminder: :environment do
    User.where.not(last_submission_date: nil).each { |it| send_we_miss_you_reminder(it) }
  end

end
