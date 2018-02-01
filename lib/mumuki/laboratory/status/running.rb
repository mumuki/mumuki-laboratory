module Status::Running
  extend Status::Base

  def self.group
    Status::Unknown
  end

  def self.iconize
    {class: :info, type: :circle}
  end
end
