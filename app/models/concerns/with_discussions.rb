module WithDiscussions
  extend ActiveSupport::Concern

  included do
    has_many :discussions, as: :item
  end

  def discuss!(user, discussion)
    discussion.merge!(initiator_id: user.id)
    discussion.merge!(submission: submission_for(user)) if submission_for(user).present?
    created_discussion = discussions.create discussion
    user.subscribe_to! created_discussion
    created_discussion
  end

  def submission_for(_)
    nil
  end

  def try_solve_discussions(user)
    discussions.where(initiator: user).map(&:try_solve!)
  end
end
