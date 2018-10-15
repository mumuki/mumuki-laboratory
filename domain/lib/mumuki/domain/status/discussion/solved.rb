module Mumuki::Domain::Status::Discussion::Solved
  extend Mumuki::Domain::Status::Discussion

  def self.solved?
    true
  end

  def self.reachable_statuses_for_moderator(*)
    [Mumuki::Domain::Status::Discussion::Opened, Mumuki::Domain::Status::Discussion::Closed]
  end

  def self.iconize
    {class: :success, type: 'check-circle'}
  end

  def self.should_be_shown?(*)
    true
  end
end
