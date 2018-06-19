class Discussion < ApplicationRecord
  include WithDiscussionStatus, ParentNavigation, Searchable

  belongs_to :item, polymorphic: true
  has_many :messages
  belongs_to :initiator, class_name: 'User'
  belongs_to :submission, optional: true
  belongs_to :exercise, foreign_type: :exercise, foreign_key: 'item_id'
  has_many :subscriptions

  scope :by_language, -> (language) { includes(:exercise).joins(exercise: :language).where(languages: {name: language}) }

  before_save :capitalize
  validates_presence_of :title

  sortable_by :created_at
  filterable_by :status, :language

  delegate :language, to: :item

  scope :for_user, -> (user) do
    if user.try(:moderator?)
      all
    else
      where.not(status: :closed).or(where(initiator: user))
    end
  end

  def capitalize
    title.capitalize!
    description.try(:capitalize!)
  end

  def used_in?(organization)
    item.used_in?(organization).present?
  end

  def commentable?(user)
    opened? && user.present?
  end

  def friendly
    title
  end

  def subscription_for(user)
    subscriptions.find_by(user: user)
  end

  def submit_message!(message, user)
    message.merge!(sender: user.uid)
    messages.create(message)
    subscription_for(user).try(:unread!)
  end

  def authorized?(user)
    initiator?(user) || user.try(:moderator?)
  end

  def initiator?(user)
    user.try(:uid) == initiator.uid
  end

  def reachable_statuses_for(user)
    return [] unless authorized?(user)
    reachable_statuses
  end

  def reachable_status_for?(user, status)
    reachable_statuses_for(user).include? status
  end

  def allowed_statuses_for(user)
    status.allowed_statuses_for(user, self)
  end

  def update_status!(status, user)
    update!(status: status) if reachable_status_for?(user, status)
  end

  def has_messages?
    messages.exists?
  end

end
