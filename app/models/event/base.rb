class Event::Base
  def notify!
    Mumukit::Nuntius.notify! queue_name, as_json unless Organization.silent?
  end

  def as_json(_options={})
    event_json.deep_merge('tenant' => Organization.current.name)
  end

end
