require 'ostruct'

class Event::Base
  def notify!(subscriber)
    subscriber.do_request(to_json, queue_name)
  end

  def to_job_params(subscriber)
    OpenStruct.new(
        subscriber_id: subscriber.id,
        event_json: to_json,
        current_book: Organization.current.name)
  end
end
