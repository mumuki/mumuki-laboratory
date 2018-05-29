module Mumuki::Laboratory::Status::Assignment::Unknown
  extend Mumuki::Laboratory::Status::Assignment

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
