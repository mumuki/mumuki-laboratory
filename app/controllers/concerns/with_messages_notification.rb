module WithMessagesNotification
  def has_messages?
    messages_count > 0
  end

  def messages_count
    current_user.try(:unread_messages).try(:count) || 0
  end
end
