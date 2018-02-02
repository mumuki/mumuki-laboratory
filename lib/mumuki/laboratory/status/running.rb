module Mumuki::Laboratory::Status::Running
  extend Mumuki::Laboratory::Status::Base

  def self.group
    Mumuki::Laboratory::Status::Unknown
  end

  def self.iconize
    {class: :info, type: :circle}
  end
end
