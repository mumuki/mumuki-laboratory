module Status::Failed
  extend Status::Base

  def self.should_retry?
    true
  end

  def self.iconize
    {class: :danger, type: 'times-circle'}
  end
end
