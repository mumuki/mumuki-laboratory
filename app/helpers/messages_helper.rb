module MessagesHelper
  def hidden_pending(assignment)
    assignment&.pending_messages? ? '' : 'hidden'
  end

  def disabled_submit_class(assignment)
    assignment&.pending_messages? ? 'disabled' : ''
  end

  def pending_messages_filter(assignment)
    'pending-messages-filter' if assignment&.pending_messages?
  end

  def read_messages_caption(assignment)
    assignment&.pending_messages? ? :read_messages : :exit
  end
end
