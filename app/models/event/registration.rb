class Event::Registration < Event::Base
  def initialize(user)
    @user = user
  end

  def event_path
    'events/registration'
  end

  def event_json
    @user.as_json(Rails.configuration.registration_notification_format).to_json
  end
end
