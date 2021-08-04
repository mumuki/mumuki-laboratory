module NotificationsHelper
  def background_for_notification(notification)
    notification.read? ? '' : 'bg-light'
  end

  def notification_preview_item(icon, name, url, **translation_params)
    menu_item icon, name, url, 'mu-notification-preview', **translation_params
  end
end
