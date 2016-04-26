class EventSubscriber < ActiveRecord::Base
  validates_presence_of :url

  def subscribed_to?(event)
    enabled
  end

  def do_request(event, queue_name)
    Mumukit::Nuntius::Publisher.send "publish_#{queue_name}", event
  end

  def self.notify!(event)
    EventSubscriber.all.select { |it| it.subscribed_to? event }.each do |it|
      event.notify! it
    end
  end

end
