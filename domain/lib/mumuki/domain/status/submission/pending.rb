module Mumuki::Domain::Status::Submission::Pending
  extend Mumuki::Domain::Status::Submission

  def self.pending?
    true
  end

  def self.iconize
    {class: :muted, type: :circle}
  end
end
