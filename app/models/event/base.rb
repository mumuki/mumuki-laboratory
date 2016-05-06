class Event::Base
  def notify!
    publish! queue_name, as_json unless Organization.current.silent?
  end

  def as_json(_options={})
    event_json.deep_merge('tenant' => Organization.current.name)
  end

  def publish!(queue_name, event)
    Mumukit::Nuntius::Publisher.publish queue_name, event
  end
end
