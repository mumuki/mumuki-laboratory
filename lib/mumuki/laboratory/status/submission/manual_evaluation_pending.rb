module Mumuki::Laboratory::Status::Submission::ManualEvaluationPending
  extend Mumuki::Laboratory::Status::Submission

  def self.passed?
    true
  end

  def self.group
    Mumuki::Laboratory::Status::Submission::Passed
  end

  def self.iconize
    {class: :info, type: 'clock-o'}
  end
end
