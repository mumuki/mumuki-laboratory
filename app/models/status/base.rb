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

  def self.iconize
    group.iconize
  end
end
