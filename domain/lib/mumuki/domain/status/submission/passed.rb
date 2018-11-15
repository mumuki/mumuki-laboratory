module Mumuki::Domain::Status::Submission::Passed
  extend Mumuki::Domain::Status::Submission

  def self.passed?
    true
  end

  def self.iconize
    {class: :success, type: 'check-circle'}
  end
end
