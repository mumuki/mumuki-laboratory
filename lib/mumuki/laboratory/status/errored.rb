module Status::Errored
  extend Status::Base

  def self.errored?
    true
  end

  def self.group
    Status::Failed
  end

  def self.iconize
    {class: :broken, type: 'minus-circle'}
  end
end
