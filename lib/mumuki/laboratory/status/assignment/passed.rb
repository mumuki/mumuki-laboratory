module Mumuki::Laboratory::Status::Assignment::Passed
  extend Mumuki::Laboratory::Status::Assignment

  def self.passed?
    true
  end

  def self.should_retry?
    false
  end

  def self.iconize
    {class: :success, type: 'check-circle'}
  end
end
