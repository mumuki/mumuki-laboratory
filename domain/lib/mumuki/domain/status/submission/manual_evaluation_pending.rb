module Mumuki::Domain::Status::Submission::ManualEvaluationPending
  extend Mumuki::Domain::Status::Submission

  def self.manual_evaluation_pending?
    true
  end

  def self.group
    Mumuki::Domain::Status::Submission::Passed
  end

  def self.iconize
    {class: :info, type: 'clock-o'}
  end
end
