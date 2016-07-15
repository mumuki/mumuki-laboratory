module Status::ManualEvaluationPending
  extend Status::Base

  def self.passed?
    true
  end

  def self.group
    Status::Passed
  end

  def self.iconize
    {class: :info, type: 'clock-o'}
  end
end
