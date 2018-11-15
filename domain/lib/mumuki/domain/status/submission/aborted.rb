module Mumuki::Domain::Status::Submission::Aborted
  extend Mumuki::Domain::Status::Submission

  def self.aborted?
    true
  end

  def self.group
    Mumuki::Domain::Status::Submission::Failed
  end
end
