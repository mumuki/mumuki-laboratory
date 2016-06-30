module NotificationMode
  def self.current
    @current_mode ||= Rails.configuration.offline_mode ? NotificationMode::Deaf.new : NotificationMode::Nuntius.new
  end
end