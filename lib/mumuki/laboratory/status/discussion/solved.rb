module Mumuki::Laboratory::Status::Discussion::Solved
  extend Mumuki::Laboratory::Status::Discussion

  def self.solved?
    true
  end

  def self.reachable_statuses_for_moderator(*)
    [Mumuki::Laboratory::Status::Discussion::Closed]
  end

  def self.iconize
    {class: :success, type: 'check-circle'}
  end

  def self.should_be_shown?(*)
    true
  end
end
