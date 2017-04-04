module MessagesHelper
  def pending_messages?(messages)
    messages&.reject(&:read).present?
  end

  def hidden_pending(messages)
    pending_messages?(messages) ? '' : 'hidden'
  end

  def disabled_submit_class(messages)
    pending_messages?(messages) ? 'disabled' : ''
  end

  def pending_messages_filter(messages)
    'pending-messages-filter' if pending_messages?(messages)
  end

  def read_messages_caption(messages)
    pending_messages?(messages) ? :read_messages : :exit
  end
end
