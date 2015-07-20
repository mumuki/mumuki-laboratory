module Status::Pending
  extend Status::Base

  def self.group
    Status::Unknown
  end

  def self.iconize
    {class: :info, type: 'clock-o'}
  end
end
