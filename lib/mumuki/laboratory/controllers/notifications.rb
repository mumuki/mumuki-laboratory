module Mumuki::Laboratory::Controllers::Notifications
  def has_notifications?
    notifications_count > 0
  end

  def notifications_count
    notifications.size
  end

  def notifications
    current_user.try(:unread_notifications) || []
  end
end
