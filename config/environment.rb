# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Returns the current mode (online or offline).
def current_mode
  if Rails.configuration.offline_mode
    OfflineMode.new
  else
    OnlineMode.new
  end
end

# Initialize the Rails application.
Rails.application.initialize!
