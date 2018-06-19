module WithDiscussions
  extend ActiveSupport::Concern

  included do
    has_many :discussions, as: :item
  end

  def create_discussion!(user, discussion)
    discussion.merge!(initiator_id: user.id)
    created_discussion = discussions.create(discussion)
    user.watched_discussions << created_discussion
    user.save!
  end
end
