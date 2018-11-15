module Mumuki::Domain::Status::Discussion::Opened
  extend Mumuki::Domain::Status::Discussion

  def self.opened?
    true
  end

  def self.reachable_statuses_for_initiator(discussion)
    if discussion.has_responses?
      [Mumuki::Domain::Status::Discussion::PendingReview]
    else
      [Mumuki::Domain::Status::Discussion::Closed]
    end
  end

  def self.reachable_statuses_for_moderator(discussion)
    if discussion.has_responses?
      [Mumuki::Domain::Status::Discussion::Closed, Mumuki::Domain::Status::Discussion::Solved]
    else
      [Mumuki::Domain::Status::Discussion::Closed]
    end
  end

  def self.iconize
    {class: :warning, type: 'question-circle'}
  end

  def self.should_be_shown?(*)
    true
  end
end
