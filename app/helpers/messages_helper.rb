module MessagesHelper
  def messages_url(exercise)
    exercise.messages_url_for(current_user) if current_user?
  end

  def hidden_pending(assignment)
    assignment.pending_messages? ? '' : 'd-none'
  end

  def disabled_submit_class(assignment)
    assignment.pending_messages? ? 'disabled' : ''
  end

  def pending_messages_filter(assignment)
    'pending-messages-filter' if assignment.pending_messages?
  end

  def read_messages_caption(assignment)
    assignment.pending_messages? ? :read_messages : :exit
  end

  def sender_class(message)
    message.blank? || message.from_user?(current_user) ? 'self' : 'other'
  end

  def staleness_class(message)
    'mu-stale' if message.stale?
  end
end
