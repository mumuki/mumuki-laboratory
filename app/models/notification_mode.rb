module NotificationMode
  extend ConfigurableGlobal

  def self.get_current
    deaf? ? NotificationMode::Deaf.new : NotificationMode::Nuntius.new
  end

  private

  def self.deaf?
    Rails.configuration.offline_mode || Rails.configuration.queueless_mode
  end
end