module UserMode
  def self.current
    @current_mode ||= Rails.configuration.offline_mode ? UserMode::SingleUser.new : UserMode::MultiUser.new
  end
end