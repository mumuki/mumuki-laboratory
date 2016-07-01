module NotificationMode
  extend ConfigurableGlobal

  def self.get_current
    Rails.configuration.offline_mode ? NotificationMode::Deaf.new : NotificationMode::Nuntius.new
  end
end