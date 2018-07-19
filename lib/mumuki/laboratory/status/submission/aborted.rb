module Mumuki::Laboratory::Status::Submission::Aborted
  extend Mumuki::Laboratory::Status::Submission

  def self.group
    Mumuki::Laboratory::Status::Submission::Failed
  end

  def aborted?
    true
  end
end
