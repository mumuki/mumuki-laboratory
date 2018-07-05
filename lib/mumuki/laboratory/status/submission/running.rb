module Mumuki::Laboratory::Status::Submission::Running
  extend Mumuki::Laboratory::Status::Submission

  def self.group
    Mumuki::Laboratory::Status::Submission::Unknown
  end

  def self.iconize
    {class: :info, type: :circle}
  end
end
