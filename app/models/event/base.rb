class Event::Base
  def notify!
    NotificationMode.current.notify! queue_name, as_json unless Organization.current.silent?
  end

  def as_json(_options={})
    event_json.deep_merge('tenant' => Organization.current.name)
  end

end
