module Mumuki::Laboratory::Status::Assignment::Running
  extend Mumuki::Laboratory::Status::Assignment

  def self.group
    Mumuki::Laboratory::Status::Assignment::Unknown
  end

  def self.iconize
    {class: :info, type: :circle}
  end
end
