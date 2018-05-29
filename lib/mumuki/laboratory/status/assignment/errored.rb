module Mumuki::Laboratory::Status::Assignment::Errored
  extend Mumuki::Laboratory::Status::Assignment

  def self.errored?
    true
  end

  def self.group
    Mumuki::Laboratory::Status::Assignment::Failed
  end

  def self.iconize
    {class: :broken, type: 'minus-circle'}
  end
end
