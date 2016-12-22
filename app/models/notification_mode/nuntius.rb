class NotificationMode::Nuntius
  def notify!(queue_name, event)
    Mumukit::Nuntius::Publisher.publish queue_name, event
  end

  def notify_event!(data, type)
    Mumukit::Nuntius::EventPublisher.publish type, data
  end
end
