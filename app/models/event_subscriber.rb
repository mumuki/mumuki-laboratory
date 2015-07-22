class EventSubscriber < ActiveRecord::Base
  validates_presence_of :url

  def notify_submission!(json)
    notify(json, 'events/submissions')
  end

  def self.notify_submission!(json)
    all.where(enabled: true).each do |it|
      it.notify_submission!(json)
    end
  end

  private

  def notify(event, path)
    response = JSON.parse(do_request(event, path))
    validate_response(response)
  end

  def do_request(event, path)
    RestClient.post("#{url}/#{path}", event, content_type: :json)
  end

  def validate_response(response)
    Rails.logger.info "response from server #{response}" if response != {'status' => 'ok'}
  end
end
