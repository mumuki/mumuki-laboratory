module WithReminders

  def build_reminder
    last_submission_date.nil? ?
      UserMailer.new.no_submissions_reminder(self) :
      UserMailer.new.we_miss_you_reminder(self, cycles_since(last_submission_date))
  end

  def send_reminder!
    build_reminder.deliver
    update! last_reminded_date: Time.now
  end

  def should_send_reminder?
    remider_due? && (has_no_submissions? || has_no_recent_submission?)
  end

  def remind!
    send_reminder! if should_send_reminder?
  end

  private

  def cycles_since(time)
    ((Date.current - time.to_date) / Rails.configuration.reminder_frequency).to_i
  end

  def remider_due?
    last_reminded_date.nil? || cycles_since(last_reminded_date) >= 1
  end

  def can_still_remind?(date)
    cycles_since(date).between?(1, 3)
  end

  def has_no_submissions?
    last_submission_date.nil? && can_still_remind?(created_at)
  end

  def has_no_recent_submission?
    !last_submission_date.nil? && can_still_remind?(last_submission_date)
  end

end
