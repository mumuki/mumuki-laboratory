module Status::Failed
  extend Status::Base

  def self.iconize
    {class: :danger, type: :times}
  end
end
