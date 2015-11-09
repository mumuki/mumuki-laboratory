class Event::Registration < Event::Base
  def initialize(user)
    @user = user
  end

  def event_path
    'events/registration'
  end

  def as_json(options={})
    @user.as_json(Rails.configuration.registration_notification_format)
  end
end
