module Mumuki::Laboratory::Status::Discussion::Solved
  extend Mumuki::Laboratory::Status::Discussion

  def self.solved?
    true
  end

  def self.reachable_statuses
    [Mumuki::Laboratory::Status::Discussion::Opened]
  end

  def self.iconize
    {class: :success, type: 'check-circle'}
  end
end
