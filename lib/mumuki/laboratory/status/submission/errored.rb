module Mumuki::Laboratory::Status::Submission::Errored
  extend Mumuki::Laboratory::Status::Submission

  def self.errored?
    true
  end

  def self.group
    Mumuki::Laboratory::Status::Submission::Failed
  end

  def self.iconize
    {class: :broken, type: 'minus-circle'}
  end
end
