# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Run differents actions in online or offline mode.
def if_online(when_online, when_offline = -> { })
  if Rails.configuration.offline_mode
    when_offline.()
  else
    when_online.()
  end
end

# Initialize the Rails application.
Rails.application.initialize!
