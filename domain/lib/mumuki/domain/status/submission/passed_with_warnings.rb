module Mumuki::Domain::Status::Submission::PassedWithWarnings
  extend Mumuki::Domain::Status::Submission

  def self.passed_with_warnings?
    true
  end

  def self.should_retry?
    true
  end

  def self.iconize
    {class: :warning, type: 'exclamation-circle'}
  end
end
