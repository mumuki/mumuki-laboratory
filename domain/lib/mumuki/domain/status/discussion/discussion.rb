module Mumuki::Domain::Status::Discussion
  include Mumuki::Domain::Status
end

require_relative './opened'
require_relative './closed'
require_relative './solved'
require_relative './pending_review'

module Mumuki::Domain::Status::Discussion
  STATUSES = [Opened, Closed, Solved, PendingReview]

  test_selectors.each do |selector|
    define_method(selector) { false }
  end

  def allowed_for?(*)
    true
  end

  def reachable_statuses_for_moderator(*)
    []
  end

  def reachable_statuses_for_initiator(*)
    []
  end

  def should_be_shown?(count, user)
    count > 0 || user&.moderator?
  end

  def reachable_statuses_for(user, discussion)
    if user.moderator?
      reachable_statuses_for_moderator(discussion)
    else
      reachable_statuses_for_initiator(discussion)
    end
  end

  def allowed_statuses_for(user, discussion)
    STATUSES.select { |it| it.allowed_for?(user, discussion) }
  end
end
