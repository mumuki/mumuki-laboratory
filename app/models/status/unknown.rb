module Status::Unknown
  extend Status::Base

  def self.to_i
    raise 'unknown status'
  end

  def self.iconize
    {class: :muted, type: :circle}
  end

  def self.should_retry?
    false
  end
end
