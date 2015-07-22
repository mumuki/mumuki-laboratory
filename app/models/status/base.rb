module Status::Base
  def to_s
    name.demodulize.underscore
  end

  def to_i
    Status::STATUSES.index(self)
  end

  def to_sym
    to_s.to_sym
  end

  def group
    self
  end

  def passed?
    false
  end

  def should_retry?
    group.should_retry?
  end

  def iconize
    group.iconize
  end

  def as_json(options={})
    to_s
  end
end
