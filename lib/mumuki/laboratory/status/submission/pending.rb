module Mumuki::Laboratory::Status::Submission::Pending
  extend Mumuki::Laboratory::Status::Submission

  def self.group
    Mumuki::Laboratory::Status::Submission::Unknown
  end

  def self.iconize
    {class: :info, type: 'clock-o'}
  end
end
