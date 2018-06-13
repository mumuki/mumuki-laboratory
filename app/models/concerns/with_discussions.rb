module WithDiscussions
  extend ActiveSupport::Concern

  included do
    has_many :discussions, as: :item
  end

  def create_discussion!(user, discussion)
    discussion.merge!(initiator_id: user.id)
    discussions.create(discussion)
  end
end
