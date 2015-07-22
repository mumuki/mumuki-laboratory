class EventNotificationJob < ActiveRecordJob
  def perform_with_connection(submission_id)
    ::EventSubscriber.notify_submission(::Submission.find(submission_id))
  end
end
