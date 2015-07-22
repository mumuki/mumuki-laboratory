class EventNotificationJob
  include SuckerPunch::Job

  def perform(json)
    Rails.logger.info("Notifying #{json}")

    ::EventSubscriber.notify_submission!(json)
  end

  def self.run_async(submission)
    new.async.perform(submission.to_json)
  end
end
