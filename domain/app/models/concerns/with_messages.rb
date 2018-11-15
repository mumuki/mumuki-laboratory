module WithMessages
  def receive_answer!(answer)
    build_message(answer).save!
  end

  def send_question!(question)
    message = build_message question.merge(sender: submitter.uid, read: true)
    message.save_and_notify!
  end

  def build_message(body)
    messages.build({date: DateTime.now}.merge(body))
  end

  def has_messages?
    messages.exists?
  end

  def pending_messages?
    messages.exists? read: false
  end
end
