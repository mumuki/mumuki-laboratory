module Mumuki::Laboratory::Status::Assignment::Failed
  extend Mumuki::Laboratory::Status::Assignment

  def self.failed?
    true
  end

  def self.should_retry?
    true
  end

  def self.iconize
    {class: :danger, type: 'times-circle'}
  end
end
