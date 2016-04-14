class EventNotificationJob < ActiveRecordJob
  def perform_with_connection(params)
    Book.find_by(name: params[:current_book]).switch!
    ::EventSubscriber.find(params.subscriber_id).post_json(params.event_json)
  end
end
