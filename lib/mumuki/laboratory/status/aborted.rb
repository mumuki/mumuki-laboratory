module Mumuki::Laboratory::Status::Aborted
  extend Mumuki::Laboratory::Status::Base

  def self.group
    Mumuki::Laboratory::Status::Failed
  end
end
