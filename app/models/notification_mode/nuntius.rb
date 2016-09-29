class NotificationMode::Nuntius
  def notify!(queue_name, event)
    Mumukit::Nuntius::Publisher.publish queue_name, event
  end

  def command_notify!(queue_name, data, type)
    Mumukit::Nuntius::CommandPublisher.publish queue_name, data, type
  end
end
