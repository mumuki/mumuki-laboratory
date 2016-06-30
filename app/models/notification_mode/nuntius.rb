class NotificationMode::Nuntius
  def notify!(queue_name, event)
    Mumukit::Nuntius::Publisher.publish queue_name, event
  end
end