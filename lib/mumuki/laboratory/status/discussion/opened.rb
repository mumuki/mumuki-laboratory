module Mumuki::Laboratory::Status::Discussion::Opened
  extend Mumuki::Laboratory::Status::Discussion

  def self.opened?
    true
  end

  def self.reachable_statuses_for_initiator(discussion)
    if discussion.has_responses?
      [Mumuki::Laboratory::Status::Discussion::PendingReview]
    else
      [Mumuki::Laboratory::Status::Discussion::Closed]
    end
  end

  def self.reachable_statuses_for_moderator(_)
    [Mumuki::Laboratory::Status::Discussion::Closed, Mumuki::Laboratory::Status::Discussion::Solved]
  end

  def self.iconize
    {class: :warning, type: 'question-circle'}
  end

  def self.should_be_shown?(*)
    true
  end
end
