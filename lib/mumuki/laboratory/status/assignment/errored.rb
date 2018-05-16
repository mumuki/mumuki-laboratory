module Mumuki::Laboratory::Status::Errored
  extend Mumuki::Laboratory::Status::Base

  def self.errored?
    true
  end

  def self.group
    Mumuki::Laboratory::Status::Failed
  end

  def self.iconize
    {class: :broken, type: 'minus-circle'}
  end
end
