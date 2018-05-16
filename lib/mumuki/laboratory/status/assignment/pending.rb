module Mumuki::Laboratory::Status::Assignment::Pending
  extend Mumuki::Laboratory::Status::Assignment

  def self.group
    Mumuki::Laboratory::Status::Assignment::Unknown
  end

  def self.iconize
    {class: :info, type: 'clock-o'}
  end
end
