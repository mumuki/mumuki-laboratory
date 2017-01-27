Mumukit::Nuntius.configure do |c|
  c.app_name = 'laboratory'
  c.notification_mode = Mumukit::Nuntius::NotificationMode.from_env
end
