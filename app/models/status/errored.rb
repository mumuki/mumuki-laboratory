module Status::Errored
  extend Status::Base

  def self.errored?
    true
  end

  def self.group
    Status::Failed
  end
end
