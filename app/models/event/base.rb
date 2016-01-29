require 'ostruct'

class Event::Base
  def notify_sync!(subscriber)
    subscriber.post_json(to_json, event_path)
  end

  def notify_async!(subscriber)
    EventNotificationJob.run_async(to_job_params(subscriber)) unless Book.current.name == 'central'
  end

  def to_job_params(subscriber)
    OpenStruct.new(
        subscriber_id: subscriber.id,
        event_json: to_json,
        event_path: event_path,
        current_book: Book.current.name)
  end
end
