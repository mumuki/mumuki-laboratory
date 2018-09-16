module Mumuki::Laboratory::Status::Submission::Aborted
  extend Mumuki::Laboratory::Status::Submission

  def self.aborted?
    true
  end

  def self.group
    Mumuki::Laboratory::Status::Submission::Failed
  end
end
