class EventSubscriber < ActiveRecord::Base
  validates_presence_of :url

  def subscribed_to?(event)
    enabled
  end

  def post_json(event, path)
    response = JSON.parse(do_request(event, path))
    validate_response(response)
  end

  def self.notify_sync!(event)
    notify! :sync, event
  end

  def self.notify_async!(event)
    notify! :async, event
  end

  private

  def self.notify!(mode, event)
    EventSubscriber.all.select { |it| it.subscribed_to? event }.each do |it|
      event.send "notify_#{mode}!", it
    end
  end

  def do_request(event, path)
    RestClient.post("#{url}/#{path}", event, content_type: :json)
  end

  def validate_response(response)
    Rails.logger.info "response from server #{response}" if response != {'status' => 'ok'}
  end
end
