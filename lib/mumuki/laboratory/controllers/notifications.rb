module Mumuki::Laboratory::Controllers::Notifications
  def notifications_path
    has_messages? ? 'messages' : 'discussions'
  end

  def has_notifications?
    notifications_count > 0
  end

  def notifications_count
    messages_count + discussions_count
  end

  private

  def has_messages?
    messages_count > 0
  end

  def messages_count
    current_user.try(:unread_messages).try(:count) || 0
  end

  def discussions_count
    current_user.try(:unread_discussions).try(:count) || 0
  end
end
