module Mumuki::Domain::Status::Submission::Running
  extend Mumuki::Domain::Status::Submission

  def self.running?
    true
  end

  def self.group
    Mumuki::Domain::Status::Submission::Pending
  end

  def self.iconize
    {class: :info, type: :circle}
  end
end
