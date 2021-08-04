module NotificationsHelper
  def background_for_notification(notification)
    notification.read? ? '' : 'bg-light'
  end
end
