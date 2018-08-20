module Mumuki::Laboratory::Status::Submission::Pending
  extend Mumuki::Laboratory::Status::Submission

  def self.pending?
    true
  end

  def self.iconize
    {class: :muted, type: :circle}
  end
end
