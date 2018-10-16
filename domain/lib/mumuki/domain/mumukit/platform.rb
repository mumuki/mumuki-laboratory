require 'mumukit/platform'

Mumukit::Platform.configure do |config|
  config.user_class_name = 'User'
  config.organization_class_name = 'Organization'
end
