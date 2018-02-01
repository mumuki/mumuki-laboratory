module Mumuki::Laboratory::Status::Failed
  extend Mumuki::Laboratory::Status::Base

  def self.should_retry?
    true
  end

  def self.iconize
    {class: :danger, type: 'times-circle'}
  end
end
