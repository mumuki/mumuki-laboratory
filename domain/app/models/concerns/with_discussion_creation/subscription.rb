module WithDiscussionCreation::Subscription
  extend ActiveSupport::Concern

  included do
    has_many :discussions, foreign_key: 'initiator_id'
    has_many :subscriptions
    has_many :watched_discussions, through: :subscriptions, source: :discussion
  end

  def subscribed_to?(discussion)
    discussion.subscription_for(self).present?
  end

  def subscribe_to!(discussion)
    watched_discussions << discussion
  end

  def unsubscribe_to!(discussion)
    watched_discussions.delete(discussion)
  end

  def toggle_subscription!(discussion)
    if subscribed_to?(discussion)
      unsubscribe_to!(discussion)
    else
      subscribe_to!(discussion)
    end
  end

  def unread_discussions
    subscriptions.where(read: false).map(&:discussion)
  end
end
