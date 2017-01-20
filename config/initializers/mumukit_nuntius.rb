Mumukit::Nuntius.configure do |c|
  c.app_name = 'atheneum'
  c.notification_mode = Mumukit::Nuntius::NotificationMode.from_env
end
