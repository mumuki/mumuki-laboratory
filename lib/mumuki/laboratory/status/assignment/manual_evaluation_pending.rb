module Mumuki::Laboratory::Status::Assignment::ManualEvaluationPending
  extend Mumuki::Laboratory::Status::Assignment

  def self.passed?
    true
  end

  def self.group
    Mumuki::Laboratory::Status::Assignment::Passed
  end

  def self.iconize
    {class: :info, type: 'clock-o'}
  end
end
