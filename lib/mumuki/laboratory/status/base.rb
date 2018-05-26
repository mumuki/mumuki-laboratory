module Mumuki::Laboratory::Status::Base
  def to_s
    name.demodulize.underscore
  end

  def to_i
    Mumuki::Laboratory::Status::STATUSES.index(self)
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

  def failed?
    false
  end

  def errored?
    false
  end

  # False if and only if this status
  # is `Mumuki::Laboratory::Status`
  def should_retry?
    true
  end

  def iconize
    group.iconize
  end

  def as_json(_options={})
    to_s
  end

  def ==(other)
    self.equal? other.to_mumuki_status rescue false
  end
end
