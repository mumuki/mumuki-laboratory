module UserMode
  extend ConfigurableGlobal
  def self.get_current
    Rails.configuration.offline_mode ? UserMode::SingleUser.new : UserMode::MultiUser.new
  end
end