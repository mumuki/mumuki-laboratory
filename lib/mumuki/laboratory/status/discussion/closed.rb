module Mumuki::Laboratory::Status::Discussion::Closed
  extend Mumuki::Laboratory::Status::Discussion

  def self.closed?
    true
  end

  def self.reachable_statuses
    [Mumuki::Laboratory::Status::Discussion::Opened]
  end

  def self.iconize
    {class: :danger, type: 'times-circle'}
  end

  def allowed_for(user, discussion)
    discussion.initiator?(user)
  end
end
