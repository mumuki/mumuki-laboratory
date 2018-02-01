module Mumuki::Laboratory::Status::ManualEvaluationPending
  extend Mumuki::Laboratory::Status::Base

  def self.passed?
    true
  end

  def self.group
    Mumuki::Laboratory::Status::Passed
  end

  def self.iconize
    {class: :info, type: 'clock-o'}
  end
end
