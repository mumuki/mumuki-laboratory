require 'mumukit/login'

Mumukit::Login.configure do |config|
  # User class must understand
  #     find_by_uid!
  #     for_profile
  config.user_class_name = 'User'
  config.framework = Mumukit::Platform::WebFramework::Rails
end
