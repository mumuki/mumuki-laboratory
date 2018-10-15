module Mumuki::Domain::Status::Discussion::PendingReview
  extend Mumuki::Domain::Status::Discussion

  def self.pending_review?
    true
  end

  def self.reachable_statuses_for_moderator(*)
    [Mumuki::Domain::Status::Discussion::Opened, Mumuki::Domain::Status::Discussion::Closed, Mumuki::Domain::Status::Discussion::Solved]
  end

  def self.iconize
    {class: :info, type: 'hourglass'}
  end
end
