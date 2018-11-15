module Mumuki::Domain::Status::Submission::Errored
  extend Mumuki::Domain::Status::Submission

  def self.errored?
    true
  end

  def self.should_retry?
    true
  end

  def self.group
    Mumuki::Domain::Status::Submission::Failed
  end

  def self.iconize
    {class: :broken, type: 'minus-circle'}
  end
end
