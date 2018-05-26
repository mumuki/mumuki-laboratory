module Mumuki::Laboratory::Status::Unknown
  extend Mumuki::Laboratory::Status::Base

  def self.to_i
    raise 'unknown status'
  end

  def self.iconize
    {class: :muted, type: :circle}
  end
end
