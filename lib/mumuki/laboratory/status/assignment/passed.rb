module Mumuki::Laboratory::Status::Passed
  extend Mumuki::Laboratory::Status::Base

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
