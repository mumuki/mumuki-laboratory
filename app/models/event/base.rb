class Event::Base
  def notify!(organization = Organization.current)
    Mumukit::Nuntius.notify! queue_name, as_json(organization: organization) unless organization.silent?
  end

  def as_json(options={})
    options[:organization] ||= Organization.current

    event_json.deep_merge('organization' => options[:organization].name)
  end

end
