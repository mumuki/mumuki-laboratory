module WithReminders

  def build_reminder(cycles)
    UserMailer.new.we_miss_you_reminder(self, cycles)
  end

  def send_reminder!(cycles)
    build_reminder(cycles).deliver
    update! last_reminded: Time.now
  end

  def cycles_since(time)
    ((Date.current - time.to_date) / Rails.configuration.reminder_frequency).to_i
  end

  def remider_due?
    last_reminded_date.nil? || cycles_since(last_reminded_date) >= 1
  end

  def should_send_reminder?
    remider_due? && cycles_since(last_submission_date).between?(1, 3)
  end

  def remind!
    send_reminder! cycles_since(last_submission_date) if should_send_reminder?
  end

end
