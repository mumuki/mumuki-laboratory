module Mumuki::Laboratory::Status::Submission::PassedWithWarnings
  extend Mumuki::Laboratory::Status::Submission

  def self.should_retry?
    true
  end

  def self.iconize
    {class: :warning, type: 'exclamation-circle'}
  end
end
