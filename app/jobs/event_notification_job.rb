class EventNotificationJob < ActiveRecordJob
  def perform_with_connection(params)
    ::EventSubscriber.find(params.subscriber_id).post_json(params.event_json, params.event_path)
  end
end
