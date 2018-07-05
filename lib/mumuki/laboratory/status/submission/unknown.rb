module Mumuki::Laboratory::Status::Submission::Unknown
  extend Mumuki::Laboratory::Status::Submission

  def self.to_i
    raise 'unknown status'
  end

  def self.iconize
    {class: :muted, type: :circle}
  end
end
