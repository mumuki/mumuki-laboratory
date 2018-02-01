module Status::Aborted
  extend Status::Base

  def self.group
    Status::Failed
  end
end
