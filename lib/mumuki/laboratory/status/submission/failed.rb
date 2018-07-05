module Mumuki::Laboratory::Status::Submission::Failed
  extend Mumuki::Laboratory::Status::Submission

  def self.failed?
    true
  end

  def self.iconize
    {class: :danger, type: 'times-circle'}
  end
end
