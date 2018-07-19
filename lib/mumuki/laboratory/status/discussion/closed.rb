module Mumuki::Laboratory::Status::Discussion::Closed
  extend Mumuki::Laboratory::Status::Discussion

  def self.closed?
    true
  end

  def self.reachable_statuses_for_moderator(*)
    [Mumuki::Laboratory::Status::Discussion::Opened, Mumuki::Laboratory::Status::Discussion::Solved]
  end

  def self.iconize
    {class: :danger, type: 'times-circle'}
  end
end
