Mumukit::Login.configure do |config|
  # User class must understand
  #     find_by_uid!
  #     for_profile
  config.user_class = User
  config.framework = Mumukit::Login::Framework::Rails
end
