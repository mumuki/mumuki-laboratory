class EventNotificationJob < ActiveRecordJob
  def perform_with_connection(solution_id)
    ::EventSubscriber.notify_submission!(::Solution.find(solution_id))
  end
end
