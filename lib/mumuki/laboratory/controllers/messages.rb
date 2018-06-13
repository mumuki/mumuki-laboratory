module Mumuki::Laboratory::Controllers::Messages
  def has_notifications?
    notifications_count > 0
  end

  def notifications_count
    messages_count + discussions_count
  end

  def messages_count
    current_user.try(:unread_messages).try(:count) || 0
  end

  def discussions_count
    current_user.try(:unread_discussions).try(:count) || 0
  end
end
