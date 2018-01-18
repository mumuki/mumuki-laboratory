module WithReminders

  def build_reminder(cycles)
    UserMailer.new.we_miss_you_reminder(self, cycles)
  end

  def send_reminder(cycles)
    build_reminder(cycles).deliver
  end

  def cycles_since_last_submission
    (Date.current - last_submission_date.to_date) / Rails.configuration.reminder_frequency
  end

  def should_send_reminder?
    cycles = cycles_since_last_submission
    cycles.denominator == 1 && cycles.between?(1, 3)
  end

  def remind!
    send_reminder cycles_since_last_submission.to_i if should_send_reminder?
  end

end
