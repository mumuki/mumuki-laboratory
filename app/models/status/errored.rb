module Status::Errored
  extend Status::Base

  def self.group
    Status::Failed
  end
end
