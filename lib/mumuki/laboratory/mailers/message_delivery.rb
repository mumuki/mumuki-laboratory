class ActionMailer::MessageDelivery
  def post!
    if in_rake_task?
      deliver_now
    else
      deliver_later
    end
  end

  private

  def in_rake_task?
    Rake.respond_to? :application
  end
end
