class EventSubscriber < ActiveRecord::Base
  validates_presence_of :url

  def subscribed_to?(event)
    enabled
  end

  def self.notify_sync!(event)
    notify! :sync, event
  end

  def self.notify_async!(event)
    notify! :async, event
  end

  def do_request(event)
    Mumukit::Nuntius::Publisher.publish_submissions event
  end

  private

  def self.notify!(mode, event)
    EventSubscriber.all.select { |it| it.subscribed_to? event }.each do |it|
      event.send "notify_#{mode}!", it
    end
  end

end
