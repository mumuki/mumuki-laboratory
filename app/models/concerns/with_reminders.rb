module WithReminders

  def build_reminder(weeks)
    UserMailer.new.we_miss_you_reminder(self, weeks)
  end

  def send_reminder(weeks)
    build_reminder(weeks).deliver
  end

  def cycles_since(a_time)
    (DateTime.now - a_time.to_date) / Rails.configuration.reminder_frequency
  end

  def should_send_reminder?(cycles)
    cycles.denominator == 1 && cycles.between?(1, 3)
  end

  def remind!
    cycles = cycles_since last_submission_date
    send_reminder cycles.to_i if should_send_reminder?(cycles)
  end

end
