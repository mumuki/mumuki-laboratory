module WithDiscussionCreation::Upvote
  extend ActiveSupport::Concern

  included do
    has_many :upvotes
    has_many :upvoted_discussions, through: :upvotes, source: :discussion
  end

  def upvoted?(discussion)
    discussion.upvote_for(self).present?
  end

  def upvote!(discussion)
    upvoted_discussions << discussion
  end

  def undo_upvote!(discussion)
    upvoted_discussions.delete(discussion)
  end

  def toggle_upvote!(discussion)
    if upvoted?(discussion)
      undo_upvote!(discussion)
    else
      upvote!(discussion)
    end
  end
end
