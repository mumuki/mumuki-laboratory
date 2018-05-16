module Mumuki::Laboratory::Status::Pending
  extend Mumuki::Laboratory::Status::Base

  def self.group
    Mumuki::Laboratory::Status::Unknown
  end

  def self.iconize
    {class: :info, type: 'clock-o'}
  end
end
