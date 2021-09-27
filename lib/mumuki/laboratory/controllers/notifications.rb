module Mumuki::Laboratory::Controllers::Notifications
  def has_notifications?
    notifications_count > 0
  end

  def has_many_notifications?
    notifications_count > 10
  end

  def notifications_count
    user_notifications.size
  end

  def user_notifications
    current_user.try(:unread_notifications) || []
  end
end
