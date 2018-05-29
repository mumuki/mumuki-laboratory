module Mumuki::Laboratory::Status::Assignment::Aborted
  extend Mumuki::Laboratory::Status::Assignment

  def self.group
    Mumuki::Laboratory::Status::Assignment::Failed
  end
end
