module Mumuki::Laboratory::Status::Discussion::Opened
  extend Mumuki::Laboratory::Status::Discussion

  def self.opened?
    true
  end

  def self.reachable_statuses
    [Mumuki::Laboratory::Status::Discussion::Closed, Mumuki::Laboratory::Status::Discussion::Solved]
  end

  def self.iconize
    {class: :info, type: 'question-circle'}
  end
end
