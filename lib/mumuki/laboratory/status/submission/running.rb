module Mumuki::Laboratory::Status::Submission::Running
  extend Mumuki::Laboratory::Status::Submission

  def self.running?
    true
  end

  def self.group
    Mumuki::Laboratory::Status::Submission::Pending
  end

  def self.iconize
    {class: :info, type: :circle}
  end
end
