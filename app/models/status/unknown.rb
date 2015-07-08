module Status::Unknown
  extend Status::Base

  def to_i
    raise 'unknown status'
  end

  def self.iconize
    {class: :muted, type: :circle}
  end
end
